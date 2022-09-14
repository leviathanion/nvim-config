local status_mason_lspconfig, mason_lspconfig= pcall(require, "mason-lspconfig")
if not status_mason_lspconfig then
  vim.notify("没有找到 mason-lspconfig")
  return
end
local status_lspconfig, lspconfig= pcall(require, "lspconfig")
if not status_lspconfig then
  vim.notify("没有找到 lspconfig")
  return
end


mason_lspconfig.setup({
    ensure_installer = {
        "pyright","sumneko_lua","html"
    },
})

-- 使用 cmp_nvim_lsp 代替内置 omnifunc，获得更强的补全体验
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

mason_lspconfig.setup_handlers {
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150
            }
        }
    end,
    -- Next, you can provide targeted overrides for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["pyright"] = function ()
        opts = require("lspconfig.pyright")
        lspconfig.pyright.setup(opts)
    end,

    ["sumneko_lua"] = function ()
        lspconfig.sumneko_lua.setup {}
    end,

    ["html"] = function ()
        lspconfig.html.setup {}
    end,
}
