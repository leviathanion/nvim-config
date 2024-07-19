local M = {}
function M.config()
    -- fidget config
    local status, wk = pcall(require, "which-key")
    if not status then
        vim.notify("没有找到 which-key")
        return
    end

    wk.add({
        {
            { "<leader>f",  group = "telescope" },
            { "<leader>fb", desc = "buffer" },
            { "<leader>ff", desc = "find files" },
            { "<leader>fg", desc = "grep" },
            { "<leader>fn", desc = "notify" },
            { "<leader>fr", desc = "recent file" }
        },
        {
            { "<leader>g",  group = "generate" },
            { "<leader>gd", desc = "docstring" }
        },
        {
            { "<leader>l",   group = "language" },
            { "<leader>la",  desc = "code_action" },
            { "<leader>ld",  desc = "hover" },
            { "<leader>lf",  group = "format" },
            { "<leader>lff", desc = "conform format" },
            { "<leader>lfl", desc = "lsp format" },
            { "<leader>lg",  group = "goto" },
            { "<leader>lgD", desc = "declaration" },
            { "<leader>lgd", desc = "definition" },
            { "<leader>lgi", desc = "implementation" },
            { "<leader>lgn", desc = "next" },
            { "<leader>lgp", desc = "prev" },
            { "<leader>lgr", desc = "references" },
            { "<leader>lgt", desc = "type_definition" },
            { "<leader>lh",  desc = "signature_help" },
            { "<leader>lo",  desc = "open float" },
            { "<leader>lq",  desc = "setloclist" },
            { "<leader>lr",  desc = "rename" },
        },
        {
            { "<leader>o",   group = "open" },
            { "<leader>oC",  group = "ChatGPT" },
            { "<leader>oCc", desc = "ChatGPT" },
            { "<leader>oCp", desc = "prompt" },
            { "<leader>ob",  desc = "sysmbols outline" },
            { "<leader>oc",  desc = "copilot panel" },
        },
        {
            { "<leader>s",  group = "split" },
            { "<leader>sc", desc = "close this window" },
            { "<leader>sh", desc = "split horizontal" },
            { "<leader>so", desc = "close other window" },
            { "<leader>sv", desc = "split vertical" },
        },
        {
            { "<leader>w",  group = "workspace" },
            { "<leader>wa", desc = "add" },
            { "<leader>wl", desc = "list" },
            { "<leader>wr", desc = "remove" }
        },
        {
            { "<leader>x",  group = "trouble" },
            { "<leader>xx", desc = "show trouble" },
        }
    })
end

return M
