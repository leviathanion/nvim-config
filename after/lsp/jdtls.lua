-- 服务端 JDK 由 JDTLS_JAVA_HOME 或 launcher 的 JAVA_HOME / PATH 规则选择。
-- 项目 JDK 单独从 JAVA_HOME / PATH 识别，避免改写服务端继承的项目环境。
local is_windows = vim.fn.has("win32") == 1
local java_name = is_windows and "java.exe" or "java"
local javac_name = is_windows and "javac.exe" or "javac"

local function normalize_home(home)
  if not home or home == "" then
    return nil
  end
  home = vim.fs.normalize(vim.fn.expand(home))
  return vim.uv.fs_realpath(home) or home
end

local function environment(config, name)
  return config.cmd_env and config.cmd_env[name] or vim.env[name]
end

local function project_runtime(config, cwd)
  local home = normalize_home(environment(config, "JAVA_HOME"))
  local executable = home and vim.fs.joinpath(home, "bin", java_name) or java_name
  -- 查询 JVM 自身，兼容 mise/asdf shim，以及 Java 8 的嵌套 jre 目录。
  local ok, process = pcall(vim.system, { executable, "-XshowSettings:properties", "-version" }, {
    text = true,
    cwd = cwd,
    env = config.cmd_env,
  })
  if not ok then
    vim.notify("jdtls: 无法执行项目 Java，请检查 JAVA_HOME / PATH", vim.log.levels.WARN)
    return
  end
  local result = process:wait(2000)
  if not result or result.code ~= 0 then
    vim.notify("jdtls: 项目 JDK 探测失败或超时，未自动配置 runtimes", vim.log.levels.WARN)
    return
  end

  local output = (result.stdout or "") .. "\n" .. (result.stderr or "")
  home = normalize_home(output:match("java%.home%s*=%s*([^\r\n]+)"))
  local version = output:match("java%.specification%.version%s*=%s*([^\r\n]+)")
  local major = version and tonumber(version:match("^1%.(%d+)") or version:match("^(%d+)"))
  if home and major == 8 and vim.fs.basename(home) == "jre" then
    local parent = vim.fs.dirname(home)
    if vim.fn.executable(vim.fs.joinpath(parent, "bin", javac_name)) == 1 then
      home = parent
    end
  end
  if
    not home
    or not major
    or major < 8
    or vim.fn.executable(vim.fs.joinpath(home, "bin", java_name)) ~= 1
    or vim.fn.executable(vim.fs.joinpath(home, "bin", javac_name)) ~= 1
  then
    vim.notify(
      "jdtls: 未识别到完整的项目 JDK（需要 Java 8+ 和 javac），请配置 runtimes",
      vim.log.levels.WARN
    )
    return
  end
  return {
    name = major == 8 and "JavaSE-1.8" or ("JavaSE-%d"):format(major),
    path = home,
    default = true,
  }
end

local function start_jdtls(dispatchers, config)
  local cwd = config.cmd_cwd or config.root_dir
  local data_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", "workspace")
  if config.root_dir then
    local root = vim.uv.fs_realpath(config.root_dir) or vim.fn.fnamemodify(config.root_dir, ":p")
    -- 完整根路径区分同名项目；真实路径让符号链接入口共用同一工作区。
    data_dir = vim.fs.joinpath(data_dir, vim.fn.sha256(vim.fs.normalize(root)))
  end

  local cmd = { "jdtls", "-data", data_dir }
  local server_home = normalize_home(environment(config, "JDTLS_JAVA_HOME"))
  if server_home then
    local executable = vim.fs.joinpath(server_home, "bin", java_name)
    if vim.fn.executable(executable) ~= 1 then
      error("jdtls: JDTLS_JAVA_HOME 下没有可执行的 " .. java_name .. ": " .. executable, 0)
    end
    -- 版本要求由 launcher 校验；显式配置错误时不悄悄换用其他 JDK。
    vim.list_extend(cmd, { "--java-executable", executable })
  end

  local configuration = config.settings.java.configuration
  if configuration.runtimes == nil then
    local runtime = project_runtime(config, cwd)
    configuration.runtimes = runtime and { runtime } or nil
  end

  local has_lombok = false
  for arg in (vim.env.JDTLS_JVM_ARGS or ""):gmatch("%S+") do
    cmd[#cmd + 1] = "--jvm-arg=" .. arg
    has_lombok = has_lombok or arg:match("^-javaagent:.*lombok[^/\\]*%.jar") ~= nil
  end
  local lombok = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "share", "jdtls", "lombok.jar")
  if not has_lombok and vim.fn.filereadable(lombok) == 1 then
    -- 直接传 argv，支持路径中的空格，也不修改全局 JVM 参数。
    cmd[#cmd + 1] = "--jvm-arg=-javaagent:" .. lombok
  end

  -- 插件的日志和工作区重建命令需要从客户端配置读取实际启动参数。
  config.cmd = cmd
  return vim.lsp.rpc.start(cmd, dispatchers, {
    cwd = cwd,
    env = config.cmd_env,
    detached = config.detached,
  })
end

local function on_attach(_, bufnr)
  -- java.inlayHints.* 默认只为字面量参数下发 hint，客户端要显式开启才会渲染。
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

return {
  cmd = start_jdtls,
  on_attach = on_attach,
  -- 优先构建根，再用仓库根合并 Maven 子模块；无版本控制时回退到构建文件。
  root_markers = {
    { "mvnw", ".mvn", "gradlew", "settings.gradle", "settings.gradle.kts" },
    { ".git" },
    { "pom.xml", "build.xml", "build.gradle", "build.gradle.kts" },
  },
  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "automatic",
      },
      maven = { downloadSources = true },
      eclipse = { downloadSources = true },
      -- Telescope 的工作区方法搜索依赖此选项。
      symbols = { includeSourceMethodDeclarations = true },
      maxConcurrentBuilds = math.max(1, math.min(2, vim.uv.available_parallelism())),
    },
  },
}
