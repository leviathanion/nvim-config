local pluginlist = {
    {
        "navarasu/onedark.nvim"
    },

    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime"
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require("configs.mason").config()
        end,
    },

    -- 通知弹窗美化
    {
        "rcarriga/nvim-notify",
        dependencies = {
            --nvim icon
            { "kyazdani42/nvim-web-devicons"}
        },
        config = function()
            require("configs.nvim-notify").config()
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        lazy = true,
        event = {"VimEnter"},
        dependencies = {
            { "kyazdani42/nvim-web-devicons"},
        },
        config = function()
            require("configs.bufferline").config()
        end,
    },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = {"BufReadPost", "BufAdd", "BufNewFile"},
        dependencies = {
            { "kyazdani42/nvim-web-devicons"},
            -- git
            { "airblade/vim-gitgutter" },
        },
        config = function()
            require("configs.lualine").config()
        end,
    },

    -- file tree
    {
        "kyazdani42/nvim-tree.lua",
        lazy = true,
        cmd = {"NvimTreeToggle"},
        config = function()
            require("configs.nvim-tree").config()
        end,
    },

    -- tagbar
    {
        "simrat39/symbols-outline.nvim",
        lazy  = true,
        cmd = {"SymbolsOutline"},
        config = function()
            require("configs.symbols-outline").config()
        end,
    },

    -- toggleterm
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("configs.toggleterm").config()
        end,
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        event = {"BufReadPost", "BufNewFile"},
        config = function()
            require("configs.treesitter").config()
        end,
    },

    -- file telescope
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        cmd = {"Telescope"},
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"BurntSushi/ripgrep"},
            {"nvim-lua/popup.nvim"}
        },
        config = function()
            require("configs.telescope").config()
        end,
    },

    -- vim-sandwich
    {
        "machakann/vim-sandwich",
        lazy = true,
        event = {"BufReadPost", "BufNewFile"},
    },

    -- indent info
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = true,
        event = {"BufReadPost"},
        config = function()
            require("configs.indent-blankline").config()
        end,
    },

    --completion
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
            },
            -- lsp
            {
                "williamboman/mason-lspconfig.nvim",
                dependencies = {
                    {"hrsh7th/cmp-nvim-lsp"},
                    {"neovim/nvim-lspconfig"},
                    {"williamboman/mason.nvim"},
                    -- lsp进度提示
                    {
                        "j-hui/fidget.nvim",
                        config = function()
                            require("configs.fidget").config()
                        end
                    },
                },
                config = function()
                    require("lsp.setup")
                    require("lspconfig.setup")
                end,
            },
            { "onsails/lspkind-nvim" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "kdheepak/cmp-latex-symbols" },
        },
        config = function()
            require("configs.cmp").config()
        end
    },

    -- copilot
    -- use "github/copilot.vim"
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        event = {"InsertEnter"},
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()
            end, 100)
        end,
        dependencies = {
            {
                "zbirenbaum/copilot-cmp",
                module = "copilot_cmp",
                dependencies = {"nvim-cmp"},
                config = function ()
                    require("copilot_cmp").setup()
                end
            },
        }
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("configs.nvim-autopairs").config()
        end
    },
    -- docstring
    {
        "danymat/neogen",
        lazy = true,
        event = "BufReadPost",
        config = function()
            require("neogen").setup {}
        end,
        dependencies = {
            {"nvim-treesitter/nvim-treesitter"},
        }
    }
}
return pluginlist
