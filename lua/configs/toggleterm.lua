local M = {}
function M.config()
    local status, toggleterm = pcall(require, "toggleterm")
    if not status then
        vim.notify("没有找到 toggleterm")
        return
    end
    toggleterm.setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = false,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "double",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    }
end
return M
