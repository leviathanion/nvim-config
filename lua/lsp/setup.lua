local lsp_installer = require "nvim-lsp-installer"
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
        update_in_insert = false
    }
)
lsp_installer.settings {
  ui = {
      icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗"
      }
  }
}

-- Include the servers you want to have installed by default below
local servers = {
  -- clangd = require("lspconfig.clangd"),
  -- bashls = require("lspconfig.bashls"),
  -- gopls = require("lspconfig.gopls"),
  pyright = require("lspconfig.pyright"),
  -- jdtls = require("lspconfig.jdtls"),
  -- yamlls = require("lspconfig.yamlls"),
  sumneko_lua = {},
  html = {}
  -- tsserver = require("lspconfig.tsserver"),
  -- bashls = require("lspconfig.bashls"),
  -- cssls = require("lspconfig.cssls"),
  -- texlab = require("lspconfig.texlab")
}

for server_name, server_options in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(server_name)
  if server_is_found and not server:is_installed() then
    vim.notify("Install Language Server : " .. server_name, "WARN", {title = "Language Servers"})
    server:install()
  end
end

-- 使用 cmp_nvim_lsp 代替内置 omnifunc，获得更强的补全体验
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)


lsp_installer.on_server_ready(function(server)
  -- Specify the default options which we'll use to setup all servers
  local opts = servers[server.name]
  if opts == nil then
    opts = {}
  end
  opts.on_attach = on_attach
  opts.flags = {
    debounce_text_changes = 150
  }
    -- 代替内置 omnifunc
  opts.capabilities = capabilities
  server:setup(opts)
end)
