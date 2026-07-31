local M = {}

function M.config()
  local ok, context = pcall(require, "treesitter-context")
  if not ok then
    vim.notify("没有找到 treesitter-context")
    return
  end

  context.setup({
    max_lines = 3,
    mode = "topline",
    on_attach = function(bufnr)
      return not vim.b[bufnr].bigfile
    end,
  })
end

return M
