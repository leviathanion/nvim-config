local status, autopairs = pcall(require, "nvim-autopairs")
if not status then
  vim.notify("没有找到 nvim-autopairs")
  return
end
local M = {}
function M.config()
    -- nvim-tree config
    autopairs.setup {

    }
end
return M
