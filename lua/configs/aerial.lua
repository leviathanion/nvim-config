local M = {}

function M.config()
  local ok, aerial = pcall(require, "aerial")
  if not ok then
    vim.notify("没有找到 aerial")
    return
  end

  aerial.setup()
end

return M
