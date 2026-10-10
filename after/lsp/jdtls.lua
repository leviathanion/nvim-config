-- 服务端需要 JDK 21+，项目可使用更早版本。保留自动发现以便跨机器复用，
-- JDTLS_JAVA_HOME 用于指定服务端 JDK，JAVA_HOME / PATH 决定默认项目 JDK。
local is_windows = vim.fn.has("win32") == 1
local java_name = is_windows and "java.exe" or "java"

local function normalize_home(home)
  if not home or home == "" then
    return nil
  end
  home = vim.fs.normalize(vim.fn.expand(home))
  return vim.uv.fs_realpath(home) or home
end

local function java_home_from_executable(executable)
  local realpath = vim.uv.fs_realpath(executable) or executable
  return vim.fs.dirname(vim.fs.dirname(realpath))
end

local function version_major(version)
  return version and tonumber(version:match("^1%.(%d+)") or version:match("^(%d+)")) or nil
end

local function java_major(home)
  local executable = vim.fs.joinpath(home, "bin", java_name)
  if vim.fn.executable(executable) ~= 1 then
    return nil
  end

  -- 优先读取标准 JDK 的 release 文件，避免启动多个 JVM 探测版本。
  local release = io.open(vim.fs.joinpath(home, "release"), "r")
  if release then
    local version = release:read("*a"):match('JAVA_VERSION="([^"]+)"')
    release:close()
    local major = version_major(version)
    if major then
      return major
    end
  end

  local ok, process = pcall(vim.system, { executable, "-version" }, { text = true })
  if not ok then
    return nil
  end
  local result = process:wait(2000)
  if result.code ~= 0 then
    return nil
  end
  local output = (result.stdout or "") .. (result.stderr or "")
  return version_major(output:match('version%s+"([^"]+)"'))
end

local function detect_jdks()
  local homes = {}
  local seen = {}

  local function add(home)
    home = normalize_home(home)
    if not home or seen[home] then
      return
    end
    seen[home] = true
    homes[#homes + 1] = home
  end

  -- 机器专用路径由环境提供。
  add(vim.env.JDTLS_JAVA_HOME)
  add(vim.env.JAVA_HOME)

  local path_java = vim.fn.exepath("java")
  if path_java ~= "" then
    add(java_home_from_executable(path_java))
  end

  local patterns = {
    "~/.sdkman/candidates/java/*",
    "~/.asdf/installs/java/*",
    "~/.local/share/mise/installs/java/*",
  }

  if is_windows then
    vim.list_extend(patterns, {
      (vim.env.ProgramFiles or "C:/Program Files") .. "/Java/*",
      (vim.env.ProgramFiles or "C:/Program Files") .. "/Eclipse Adoptium/*",
      (vim.env.ProgramFiles or "C:/Program Files") .. "/Microsoft/jdk-*",
      (vim.env.USERPROFILE or "~") .. "/scoop/apps/*jdk*/current",
    })
  else
    vim.list_extend(patterns, {
      "/usr/lib/jvm/*",
      "/Library/Java/JavaVirtualMachines/*/Contents/Home",
      "~/Library/Java/JavaVirtualMachines/*/Contents/Home",
    })
  end

  for _, pattern in ipairs(patterns) do
    for _, home in ipairs(vim.fn.glob(pattern, false, true)) do
      add(home)
    end
  end

  local jdks = {}
  for _, home in ipairs(homes) do
    local major = java_major(home)
    if major then
      jdks[#jdks + 1] = { home = home, major = major }
    end
  end

  return jdks
end

local function runtime_name(major)
  return major == 8 and "JavaSE-1.8" or ("JavaSE-%d"):format(major)
end

local function build_runtime_config(jdks)
  local runtimes = {}
  local seen_major = {}
  local default_home = vim.env.JAVA_HOME

  if not default_home or default_home == "" then
    local path_java = vim.fn.exepath("java")
    default_home = path_java ~= "" and java_home_from_executable(path_java) or nil
  end
  default_home = normalize_home(default_home)

  table.sort(jdks, function(a, b)
    if a.major ~= b.major then
      return a.major < b.major
    end
    if (a.home == default_home) ~= (b.home == default_home) then
      return a.home == default_home
    end
    return a.home < b.home
  end)

  for _, jdk in ipairs(jdks) do
    if jdk.major >= 8 and not seen_major[jdk.major] then
      seen_major[jdk.major] = true
      runtimes[#runtimes + 1] = {
        name = runtime_name(jdk.major),
        path = jdk.home,
        default = jdk.home == default_home or nil,
      }
    end
  end

  return runtimes
end

local function find_server_runtime(jdks)
  local preferred = normalize_home(vim.env.JDTLS_JAVA_HOME)

  local best
  for _, jdk in ipairs(jdks) do
    if jdk.major >= 21 then
      if jdk.home == preferred then
        return jdk.home
      end
      if not best or jdk.major > best.major then
        best = jdk
      end
    end
  end

  return best and best.home or nil
end

local function start_jdtls(dispatchers, config)
  local data_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", "workspace")
  if config.root_dir then
    local root = vim.uv.fs_realpath(config.root_dir) or vim.fn.fnamemodify(config.root_dir, ":p")
    -- 完整根路径区分同名项目；真实路径让符号链接入口共用同一工作区。
    data_dir = vim.fs.joinpath(data_dir, vim.fn.sha256(vim.fs.normalize(root)))
  end

  local cmd = { "jdtls", "-data", data_dir }
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
    cwd = config.cmd_cwd,
    env = config.cmd_env,
    detached = config.detached,
  })
end

local function on_attach(_, bufnr)
  -- java.inlayHints.* 默认只为字面量参数下发 hint，客户端要显式开启才会渲染。
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

local jdks = detect_jdks()
local server_runtime = find_server_runtime(jdks)
local runtimes = build_runtime_config(jdks)

return {
  cmd = start_jdtls,
  cmd_env = server_runtime and { JAVA_HOME = server_runtime } or nil,
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
        runtimes = #runtimes > 0 and runtimes or nil,
      },
      maven = { downloadSources = true },
      eclipse = { downloadSources = true },
      -- Telescope 的工作区方法搜索依赖此选项。
      symbols = { includeSourceMethodDeclarations = true },
      maxConcurrentBuilds = math.max(1, math.min(2, vim.uv.available_parallelism())),
    },
  },
}
