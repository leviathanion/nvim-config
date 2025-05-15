local M = {}
function M.config()
    vim.diagnostic.config(
        {
            virtual_lines = {
                current_line = true
            },
            -- 在插入模式下是否显示诊断？不要
            update_in_insert = true
        }
    )
    vim.lsp.enable({ "lua_ls", "pyright" })
end

return M
