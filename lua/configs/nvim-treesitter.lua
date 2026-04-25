local user_settings = require("core.options")

local M = {}

local ensure_installed = {
  "bash",
  "go",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "zig",
}

function M.config()
  local ok, treesitter = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("没有找到 nvim-treesitter")
    return
  end

  local parsers = require("nvim-treesitter.parsers")

  if user_settings.global_options.useMirror then
    for _, parser in pairs(parsers) do
      local install_info = parser.install_info
      if install_info and install_info.url then
        install_info.url = install_info.url:gsub(
          "https://github.com/",
          user_settings.global_options.mirrorURL
        )
      end
    end
  end

  treesitter.setup({})

  local pending_buffers = {}
  local installing = {}

  local function parser_is_installed(lang)
    return vim.list_contains(treesitter.get_installed("parsers"), lang)
  end

  local function notify_install_failed(lang, err)
    local message = ("treesitter parser 安装失败: %s"):format(lang)
    if err then
      message = ("%s\n%s"):format(message, err)
    end
    vim.notify(message, vim.log.levels.WARN)
  end

  local function set_feature_options(buf, win)
    vim.api.nvim_set_option_value(
      "indentexpr",
      "v:lua.require'nvim-treesitter'.indentexpr()",
      { buf = buf }
    )

    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
      vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { win = win })
      vim.api.nvim_set_option_value("foldlevel", 99, { win = win })
    end
  end

  local function start_features(buf, lang)
    if not vim.api.nvim_buf_is_valid(buf) then
      return false
    end

    return pcall(vim.treesitter.start, buf, lang)
  end

  local function install_then_start(lang)
    if installing[lang] then
      return
    end

    installing[lang] = true
    treesitter.install({ lang }):await(function(err, success)
      local buffers = pending_buffers[lang] or {}
      pending_buffers[lang] = nil
      installing[lang] = nil

      vim.schedule(function()
        if err or not success then
          notify_install_failed(lang, err)
          return
        end

        for buf in pairs(buffers) do
          start_features(buf, lang)
        end
      end)
    end)
  end

  local function ensure_core_parsers()
    local missing = vim.tbl_filter(function(lang)
      return parsers[lang] and not parser_is_installed(lang)
    end, ensure_installed)

    if #missing == 0 then
      return
    end

    -- Trade-off: this restores old "no manual TSInstall" behavior for the common
    -- languages in this config. It may spend network/compile time on startup, while
    -- uncommon languages are still installed lazily on first open.
    treesitter.install(missing, { summary = true }):await(function(err, success)
      if err or not success then
        notify_install_failed(table.concat(missing, ", "), err)
      end
    end)
  end

  ensure_core_parsers()

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterAutoFeatures", { clear = true }),
    callback = function(args)
      local filetype = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(filetype) or filetype
      if not parsers[lang] then
        return
      end

      set_feature_options(args.buf, vim.api.nvim_get_current_win())

      if start_features(args.buf, lang) then
        return
      end

      pending_buffers[lang] = pending_buffers[lang] or {}
      pending_buffers[lang][args.buf] = true
      install_then_start(lang)
    end,
  })
end

return M
