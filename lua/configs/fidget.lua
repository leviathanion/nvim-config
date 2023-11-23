local M = {}
function M.config()
    -- fidget config
    local status, fidget = pcall(require, "fidget")
    if not status then
        vim.notify("没有找到 fidget")
        return
    end
    fidget.setup {
        --        blend = 0,
    }
end

return M
