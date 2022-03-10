-- nvim-lspconfig config
-- List of all pre-configured LSP servers:
-- github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {'ccls', 'pyright', "jdtls", "yamlls", "sumneko_lua", 'html', 'tsserver', 'bashls', 'cssls', 'texlab' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150
          }
    }
end


local lsp_installer = require "nvim-lsp-installer"

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
  "ccls",
  "pyright",
  "jdtls",
  "yamlls",
  "sumneko_lua",
  "html",
  "tsserver",
  "bashls",
  "cssls",
  "texlab"
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

lsp_installer.on_server_ready(function(server)
  -- Specify the default options which we'll use to setup all servers
  local opts = {}
  server:setup(opts)
end)
