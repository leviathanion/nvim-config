local general_group = vim.api.nvim_create_augroup("myAutoGroup", { clear = true })
local format_group = vim.api.nvim_create_augroup("formatOnSave", { clear = true })
local lint_group = vim.api.nvim_create_augroup("lintOnChange", { clear = true })
local input_group = vim.api.nvim_create_augroup("fcitxIntegration", { clear = true })

local autocmd = vim.api.nvim_create_autocmd

local format_filetypes = {
  javascript = true,
  javascriptreact = true,
  json = true,
  lua = true,
  python = true,
  sh = true,
  typescript = true,
  typescriptreact = true,
}

local lint_filetypes = {
  javascript = true,
  javascriptreact = true,
  python = true,
  typescript = true,
  typescriptreact = true,
}

local function can_edit_buffer(bufnr)
  return vim.bo[bufnr].buftype == "" and vim.bo[bufnr].modifiable
end

autocmd("BufWritePre", {
  group = format_group,
  callback = function(args)
    if not can_edit_buffer(args.buf) then
      return
    end

    local filetype = vim.bo[args.buf].filetype
    if not format_filetypes[filetype] then
      return
    end

    require("conform").format({
      bufnr = args.buf,
      async = false,
      lsp_format = "fallback",
    })
  end,
})

autocmd({ "BufWritePost", "InsertLeave" }, {
  group = lint_group,
  callback = function(args)
    if not can_edit_buffer(args.buf) then
      return
    end

    local filetype = vim.bo[args.buf].filetype
    if not lint_filetypes[filetype] then
      return
    end

    require("lint").try_lint(nil, { ignore_errors = true })
  end,
})

autocmd("BufEnter", {
  group = general_group,
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o" + "r"
  end,
})

local has_fcitx = vim.fn.executable("fcitx5-remote") == 1
if has_fcitx then
  autocmd("InsertEnter", {
    group = input_group,
    pattern = "*.md",
    callback = function()
      vim.system({ "fcitx5-remote", "-o" }, { text = true })
    end,
  })

  autocmd({ "InsertLeave", "BufLeave" }, {
    group = input_group,
    pattern = "*.md",
    callback = function()
      vim.system({ "fcitx5-remote", "-c" }, { text = true })
    end,
  })
end
