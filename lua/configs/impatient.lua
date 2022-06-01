local status, indent_blankline = pcall(require, "impatient")
if not status then
  vim.notify("没有找到 impatient")
  return
end
local M = {}
function M.config()
    require("impatient")
end

return M
