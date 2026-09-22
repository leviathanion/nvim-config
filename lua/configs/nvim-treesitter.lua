local user_settings = require("core.options")

local M = {}

local ensure_installed = {
  "bash",
  "go",
  "java",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
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

  local function apply_parser_mirror()
    if not user_settings.global_options.useMirror then
      return
    end

    for _, parser in pairs(require("nvim-treesitter.parsers")) do
      local install_info = parser.install_info
      if install_info and install_info.url then
        install_info.url = install_info.url:gsub(
          "^https://github%.com/",
          function()
            return user_settings.global_options.mirrorURL
          end
        )
      end
    end
  end

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("TreesitterParserMirror", { clear = true }),
    pattern = "TSUpdate",
    callback = apply_parser_mirror,
  })
  apply_parser_mirror()

  treesitter.setup({})

  local pending_buffers = {}
  local installing = {}

  local function notify_install_failed(lang, err)
    local message = ("treesitter parser 安装失败: %s"):format(lang)
    if err then
      message = ("%s\n%s"):format(message, err)
    end
    vim.notify(message, vim.log.levels.WARN)
  end

  local function set_indent(buf)
    vim.api.nvim_set_option_value(
      "indentexpr",
      "v:lua.require'nvim-treesitter'.indentexpr()",
      { buf = buf }
    )
  end

  local function start_features(buf, lang)
    if not vim.api.nvim_buf_is_valid(buf)
      or not vim.api.nvim_buf_is_loaded(buf)
      or vim.b[buf].bigfile
    then
      return false
    end

    local filetype = vim.bo[buf].filetype
    local current_lang = vim.treesitter.language.get_lang(filetype) or filetype
    if current_lang ~= lang then
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
    local parsers = require("nvim-treesitter.parsers")
    local installed = {}
    for _, lang in ipairs(treesitter.get_installed("parsers")) do
      installed[lang] = true
    end

    local missing = vim.tbl_filter(function(lang)
      return parsers[lang] and not installed[lang]
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
      if vim.b[args.buf].bigfile then
        return
      end

      local filetype = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(filetype) or filetype
      if not require("nvim-treesitter.parsers")[lang] then
        return
      end

      set_indent(args.buf)

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
