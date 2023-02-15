local user_settings = require("core.options")
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_bootstrap
if not vim.loop.fs_stat(install_path) then
--  vim.notify("正在安装Lazy.nvim，请稍后...")
  lazy_bootstrap = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)
-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify("没有安装 lazy.nvim")
  return
end

-- lazy.init({
--     git = {
--         -- For Chinese users, if the download is slow, you can switch to the github mirror source
--         -- replace : https://hub.fastgit.xyz/%s
--         -- default_url_format = "https://github.com/%s",
--          default_url_format = user_settings.global_options.useMirror and "https://github.leviathanion.workers.dev/%s" 
--                 or "https://github.com/%s.git",
--     },
-- })

lazy.setup({
    --nvim icon
    {
        'kyazdani42/nvim-web-devicons',
    },

    -- git
    {
        'airblade/vim-gitgutter',
    },

    -- theme
    {
        'navarasu/onedark.nvim'
    },

    {
        'onsails/lspkind-nvim',
    },

    {
        'dstein64/vim-startuptime',
        cmd = "StartupTime"
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require("configs.mason").config()
        end,
    },

    -- 通知弹窗美化
    {
        'rcarriga/nvim-notify',
        dependencies = {"nvim-web-devicons"},
        config = function()
            require("configs.nvim-notify").config()
        end,
    },

    -- bufferline
    {
        'akinsho/bufferline.nvim',
        dependencies = {"nvim-web-devicons"},
        config = function()
            require("configs.bufferline").config()
        end,
    },

    -- status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {"nvim-web-devicons", "vim-gitgutter"},
        config = function()
            require("configs.lualine").config()
        end,
    },

    -- file tree
    {
        'kyazdani42/nvim-tree.lua',
        cmd = {"NvimTreeToggle"},
        config = function()
            require("configs.nvim-tree").config()
        end,
    },

    -- tagbar
    {
        'simrat39/symbols-outline.nvim',
        cmd = {"SymbolsOutline"},
        config = function()
            require("configs.symbols-outline").config()
        end,
    },

    -- toggleterm
    {
        'akinsho/toggleterm.nvim',
        config = function()
            require("configs.toggleterm").config()
        end,
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require("configs.treesitter").config()
        end,
    },

    -- file telescope
    {
       'nvim-telescope/telescope.nvim',
        dependencies = {
            {'nvim-lua/plenary.nvim'},
            {'BurntSushi/ripgrep'},
            {'nvim-lua/popup.nvim'}
        },
        config = function()
            require("configs.telescope").config()
        end,
    },

    -- vim-sandwich
    {
        'machakann/vim-sandwich',
        event = {"BufRead"},
    },

    -- indent info
    {
        'lukas-reineke/indent-blankline.nvim',
        event = {"BufRead"},
        config = function()
            require("configs.indent-blankline").config()
        end,
    },

    -- copilot
    -- use 'github/copilot.vim'
    {
        "zbirenbaum/copilot.lua", 
        event = {"VimEnter"},
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()
            end, 100)
        end,
    },
    -- lsp
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
        },
        config = function()
            require("lsp.setup")
            require("lspconfig.setup")
        end,
    },

    -- lsp进度提示
    {
        'j-hui/fidget.nvim',
        dependencies = {"mason.nvim"},
        config = function()
            require("configs.fidget").config()
        end
    },
    --completion
    {
        'rafamadriz/friendly-snippets',
        event = { "InsertEnter", "CmdlineEnter" },
    },
    {
        'L3MON4D3/LuaSnip',
        ptp = "viml",
        dependencies = { "friendly-snippets" },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = { "LuaSnip", "lspkind-nvim" },
        config = function()
            require("configs.cmp").config()
        end
    },
    {
        'hrsh7th/cmp-buffer',
        dependencies = {"nvim-cmp"}
    },
    {
        'hrsh7th/cmp-path',
        dependencies = {"nvim-cmp"}
    },
    {
        'hrsh7th/cmp-cmdline',
        dependencies = {"nvim-cmp"}
    },
    {
        'hrsh7th/cmp-nvim-lua',
        dependencies = {"nvim-cmp"}
    },
    {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        dependencies = {"nvim-cmp"}
    },
    {"zbirenbaum/copilot-cmp",
        module = "copilot_cmp",
        dependencies = {"nvim-cmp","copilot.lua"},
        config = function ()
            require("copilot_cmp").setup()
        end
    },
    -- latex support
    {
        'kdheepak/cmp-latex-symbols',
        dependencies = {"nvim-cmp"}
    },
    -- autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require("configs.nvim-autopairs").config()
        end
    },
    -- docstring
    {
        "danymat/neogen",
        event = "BufRead",
        config = function()
            require('neogen').setup {}
        end,
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
})

