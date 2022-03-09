local M = {}
function M.config()
    -- nvim-tree config
    require'nvim-tree'.setup {
        -- 关闭文件时自动关闭
        auto_close = true
    }
end

return M