local M = {}
function M.config()
    local status, indent_blankline = pcall(require, "indent_blankline")
    if not status then
        vim.notify("没有找到 indent_blankline")
        return
    end
    -- indent_blankline config
    indent_blankline.setup {
        -- 显示当前所在区域
        show_current_context = true,
        -- 显示当前所在区域的开始位置
        show_current_context_start = true,
        -- 显示行尾符
        show_end_of_line = true,
    }
end

return M
