-- JDTLS needs JDK 21+, while a project may target an older JDK. The extra
-- discovery code is an intentional portability trade-off: this dotfile stays
-- path-free across OSes and JDK managers, with JDTLS_JAVA_HOME as an override.
local is_windows = vim.fn.has("win32") == 1
local java_name = is_windows and "java.exe" or "java"

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

  -- Every standard JDK ships this file; reading it avoids starting several JVMs
  -- during Neovim startup. Fall back to `java -version` for unusual layouts.
  local release = io.open(vim.fs.joinpath(home, "release"), "r")
  if release then
    local version = release:read("*a"):match('JAVA_VERSION="([^"]+)"')
    release:close()
    if version then
      return version_major(version)
    end
  end

  local result = vim.system({ executable, "-version" }, { text = true }):wait()
  local output = (result.stdout or "") .. (result.stderr or "")
  return version_major(output:match('version%s+"([^"]+)"'))
end

local function detect_jdks()
  local homes = {}
  local seen = {}

  local function add(home)
    if not home or home == "" then
      return
    end

    home = vim.fs.normalize(vim.fn.expand(home))
    local realpath = vim.uv.fs_realpath(home) or home
    if seen[realpath] then
      return
    end

    seen[realpath] = true
    homes[#homes + 1] = realpath
  end

  -- Machine-specific paths belong in the environment, not in this dotfile.
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
  default_home = default_home and (vim.uv.fs_realpath(default_home) or default_home) or nil

  table.sort(jdks, function(a, b)
    return a.major < b.major
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
  local preferred = vim.env.JDTLS_JAVA_HOME
  preferred = preferred and (vim.uv.fs_realpath(preferred) or preferred) or nil

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

local function enable_mason_lombok()
  local lombok = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "share", "jdtls", "lombok.jar")
  if vim.fn.filereadable(lombok) ~= 1 or lombok:find("%s") then
    -- nvim-lspconfig's JDTLS_JVM_ARGS parser is whitespace-delimited; skipping
    -- the optional agent is safer than breaking JDTLS on a path with spaces.
    return
  end

  local args = vim.env.JDTLS_JVM_ARGS or ""
  if not args:find("lombok%.jar", 1, false) then
    vim.env.JDTLS_JVM_ARGS = vim.trim(args .. " -javaagent:" .. lombok)
  end
end

local function make_config()
  local jdks = detect_jdks()
  local server_runtime = find_server_runtime(jdks)
  local configuration = {
    -- Keep Maven/Gradle classpaths in sync when their build files change.
    updateBuildConfiguration = "automatic",
  }
  local runtimes = build_runtime_config(jdks)
  if #runtimes > 0 then
    configuration.runtimes = runtimes
  end

  enable_mason_lombok()

  local max_concurrent_builds = math.max(1, math.min(2, vim.uv.available_parallelism()))

  local config = {
    -- Wrappers/settings identify the build root. A repository root keeps a
    -- multi-module Maven project in one JDTLS client; build files are the
    -- fallback for projects that are not in version control.
    root_markers = {
      { "mvnw", ".mvn", "gradlew", "settings.gradle", "settings.gradle.kts" },
      { ".git" },
      { "pom.xml", "build.xml", "build.gradle", "build.gradle.kts" },
    },
    settings = {
      java = {
        configuration = configuration,
        import = {
          maven = { enabled = true },
          gradle = {
            enabled = true,
            wrapper = { enabled = true },
          },
        },
        maven = { downloadSources = true },
        eclipse = { downloadSources = true },
        -- Required for Telescope's workspace-wide method search.
        symbols = {
          includeSourceMethodDeclarations = true,
          includeGeneratedCode = false,
        },
        search = { scope = "all" },
        maxConcurrentBuilds = max_concurrent_builds,
      },
    },
  }

  if server_runtime then
    config.cmd_env = { JAVA_HOME = server_runtime }
  end

  return config
end

return make_config()
