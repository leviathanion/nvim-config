local user_settings = require("core.options")

local M = {}

function M.config()
  local ok, treesitter = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("没有找到 nvim-treesitter")
    return
  end

  if user_settings.global_options.useMirror then
    for _, parser in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
      parser.install_info.url = parser.install_info.url:gsub(
        "https://github.com/",
        user_settings.global_options.mirrorURL
      )
    end
  end

  treesitter.setup({})

  local enabled_filetypes = {
    bash = true,
    go = true,
    javascript = true,
    javascriptreact = true,
    json = true,
    lua = true,
    markdown = true,
    python = true,
    query = true,
    rust = true,
    sh = true,
    typescript = true,
    typescriptreact = true,
    vim = true,
    zig = true,
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitterFeatures", { clear = true }),
    callback = function(args)
      local filetype = vim.bo[args.buf].filetype
      if not enabled_filetypes[filetype] then
        return
      end

      local lang = vim.treesitter.language.get_lang(filetype) or filetype
      if not pcall(vim.treesitter.language.add, lang) then
        return
      end

      pcall(vim.treesitter.start, args.buf, lang)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0].foldmethod = "expr"
      vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0].foldlevel = 99
    end,
  })
end

return M
