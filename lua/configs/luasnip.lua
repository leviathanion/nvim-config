local M = {}
function M.config()
    local status, _ = pcall(require, "luasnip")
    if not status then
        vim.notify("没有找到 LuaSnip")
        return
    end

    require("luasnip.loaders.from_vscode").lazy_load()
end

return M
