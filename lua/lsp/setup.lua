local user_settings = require("core.options")
local status_mason, mason = pcall(require, "mason")
if not status_mason then
    vim.notify("没有找到 mason")
    return
end

local servers = {
    -- clangd = require("lspconfig.clangd"),
    -- bashls = require("lspconfig.bashls"),
    -- gopls = require("lspconfig.gopls"),
    -- pyright = require("lspconfig.pyright"),
    -- jdtls = require("lspconfig.jdtls"),
    -- yamlls = require("lspconfig.yamlls"),
    -- sumneko_lua = {},
    -- html = {}
    -- tsserver = require("lspconfig.tsserver"),
    -- bashls = require("lspconfig.bashls"),
    -- cssls = require("lspconfig.cssls"),
    -- texlab = require("lspconfig.texlab")
    "pyright", "html-lsp", "lua-language-server"
}

for index, server_name in ipairs(servers) do
    local server = require("mason-registry").get_package(server_name)
    if not server:is_installed() then
        vim.notify("Install Language Server : " .. server_name, "WARN", { title = "Language Servers" })
        server:install()
    end
end

vim.diagnostic.config(
    {
        -- 诊断的虚拟文本
        virtual_text = {
            -- 显示的前缀，可选项：'●', '▎', 'x'
            -- 默认是一个小方块，不是很好看，所以这里改了
            prefix = "●",
            -- 是否总是显示前缀？是的
            source = "always"
        },
        float = {
            -- 是否显示诊断来源？是的
            source = "always"
        },
        -- 在插入模式下是否显示诊断？不要
        update_in_insert = true
    }
)
