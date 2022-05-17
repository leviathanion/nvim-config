local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
  vim.notify("没有找到 nvim-tree")
  return
end
local M = {}
function M.config()
    -- nvim-tree config
    nvim_tree.setup {

    }
end
return M
