local M = {}
function M.config()
  local status, wk = pcall(require, "which-key")
  if not status then
    vim.notify("没有找到 which-key")
    return
  end

  wk.add({
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "git hunk" },
    { "<leader>l", group = "lsp" },
    { "<leader>la", group = "actions" },
    { "<leader>lf", group = "format" },
    { "<leader>lg", group = "goto" },
    { "<leader>lq", group = "diagnostics" },
    { "<leader>o", group = "open" },
    { "<leader>s", group = "split" },
    { "<leader>t", group = "terminal" },
    { "<leader>w", group = "workspace" },
  })
end

return M
