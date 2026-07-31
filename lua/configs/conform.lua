local M = {}
function M.config()
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("没有找到 conform")
    return
  end

  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "jq" },
      sh = { "shfmt" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    },
    notify_on_error = false,
    formatters = {
      shfmt = {
        prepend_args = { "-i", "4" },
      },
    },
  })
end

return M
