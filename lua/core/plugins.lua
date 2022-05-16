return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- buffer
    use 'akinsho/bufferline.nvim'
    -- file telescope
    use {
       'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'BurntSushi/ripgrep'},
            {'nvim-lua/popup.nvim'}
        }
    }
    -- themes (disabled other themes to optimize startup time)
    -- use 'sainnhe/sonokai'
     use 'joshdick/onedark.vim'
--    use { 'catppuccin/nvim', as='catppuccin' }
--    use { 'sonph/onehalf', rtp='vim/' }
--    use 'liuchengxu/space-vim-dark'
--    use 'ahmedabdulrahman/aylin.vim'

    -- file tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- language
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'onsails/lspkind-nvim'
    use 'saadparwaiz1/cmp_luasnip'
    -- latex support
    use 'kdheepak/cmp-latex-symbols'

    -- git
    use 'airblade/vim-gitgutter' -- TODO: better git integration

    -- status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- tagbar
    use 'simrat39/symbols-outline.nvim'

    -- floating terminal
    use 'voldikss/vim-floaterm'


    -- treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- vimshell
    use 'skywind3000/asyncrun.vim'

    -- toggleterm
    use 'akinsho/toggleterm.nvim'

    -- vim-sandwich
    use 'machakann/vim-sandwich'
    -- copilot
    -- use 'github/copilot.nvim'
    -- indent info
    use 'lukas-reineke/indent-blankline.nvim'
    -- autopairs
    use 'windwp/nvim-autopairs'
    -- LSP进度提示
    use 'j-hui/fidget.nvim'
    -- 通知弹窗美化
    use 'rcarriga/nvim-notify'
end)

