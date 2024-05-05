local M = {}
function M.config()
    -- fidget config
    local status, wk = pcall(require, "which-key")
    if not status then
        vim.notify("没有找到 which-key")
        return
    end

    wk.register({
        ["<leader>f"] = {
            name = "telescope",
            f = "find files",
            g = "grep",
            r = "recent file",
            b = "buffer",
            n = "notify"
        },
        ["<leader>l"] = {
            name = "language",
            g = {
                name = "goto",
                D = "declaration",
                d = "definition",
                t = "type_definition",
                i = "implementation",
                p = "prev",
                n = "next",
                r = "references"
            },
            o = "open float",
            q = "setloclist",
            d = "hover",
            r = "rename",
            h = "signature_help",
            a = "code_action",
            f = {
                name = "format",
                l = "lsp format",
                f = "conform format"
            },
        },
        ["<leader>s"] = {
            name = "split",
            c = "close this window",
            o = "close other window",
            h = "split horizontal",
            v = "split vertical"
        },
        ["<leader>w"] = {
            name = "workspace",
            a = "add",
            r = "remove",
            l = "list"
        },
        ["<leader>o"] = {
            name = "open",
            b = "sysmbols outline",
            c = "copilot panel",
        },
        ["<leader>g"] = {
            name = "generate",
            d = "docstring"
        },
        ["<leader>oC"] = {
            name = "ChatGPT",
            c = "ChatGPT",
            p = "prompt"
        },
        ["<leader>x"] = {
            name = "trouble",
            x = "show trouble",
        },

    })
end

return M
