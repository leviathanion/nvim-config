local M = {}

function M.config()
  local ok, indent_blankline = pcall(require, "ibl")
  if not ok then
    vim.notify("没有找到 indent_blankline")
    return
  end

  indent_blankline.setup()
end

return M
