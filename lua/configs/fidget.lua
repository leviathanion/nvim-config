local status, fidget = pcall(require, "fidget")
if not status then
  vim.notify("没有找到 fidget")
  return
end
local M = {}
function M.config()
    -- fidget config
    fidget.setup {
        blend = 0,
    }
end
return M
