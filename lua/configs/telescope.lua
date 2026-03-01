local M = {}
function M.config()
    local status, telescope = pcall(require, "telescope")
    if not status then
        vim.notify("没有找到 telescope")
        return
    end
    telescope.setup {
    }
    telescope.load_extension("live_grep_args")
end

return M
