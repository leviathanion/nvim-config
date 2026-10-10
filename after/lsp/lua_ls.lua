return {
  before_init = function(_, config)
    local root = type(config.root_dir) == "string" and vim.uv.fs_realpath(config.root_dir) or nil
    local config_root = vim.uv.fs_realpath(vim.fn.stdpath("config"))
    if not root or root ~= config_root then
      return
    end
    if vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc") then
      return
    end

    -- 只为本配置补充 Neovim 类型；项目自己的 LuaLS 配置始终优先。
    -- 原地更新 settings，让客户端的首次配置通知包含这些设置。
    config.settings.Lua = vim.tbl_deep_extend("force", config.settings.Lua or {}, {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua" },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    })
  end,
  settings = { Lua = {} },
}
