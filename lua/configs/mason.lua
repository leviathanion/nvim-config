local M = {}
function M.config()
    local status_mason, mason = pcall(require, "mason")
    if not status_mason then
        vim.notify("没有找到 mason")
        return
    end
    mason.setup()
end

return M
