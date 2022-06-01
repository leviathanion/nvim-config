local M = {}
function M.config()
    local status, impatient= pcall(require, "impatient")
    if not status then
        vim.notify("没有找到 impatient")
        return
    end
    require("impatient")
end

return M
