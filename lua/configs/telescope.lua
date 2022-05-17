local status, telescope= pcall(require, "telescope")
if not status then
    vim.notify("没有找到 telescope")
    return
end
local M = {}
function M.config()
    telescope.setup {
    }
end
return M
