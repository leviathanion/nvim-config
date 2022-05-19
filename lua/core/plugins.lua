local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local paccker_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify("正在安装Pakcer.nvim，请稍后...")
  paccker_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    -- "https://gitcode.net/mirrors/wbthomason/packer.nvim",
    install_path,
  })

  -- https://github.com/wbthomason/packer.nvim/issues/750
  local rtp_addition = vim.fn.stdpath("data") .. "/site/pack/*/start/*"
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. "," .. vim.o.runtimepath
  end
  vim.notify("Pakcer.nvim 安装完毕")
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("没有安装 packer.nvim")
  return
end

packer.init({
    git = {
        -- For Chinese users, if the download is slow, you can switch to the github mirror source
        -- replace : https://hub.fastgit.xyz/%s
        -- default_url_format = "https://github.com/%s",
        default_url_format = "https://hub.fastgit.xyz/%s",
    },
})

packer.startup(function()
    use 'wbthomason/packer.nvim'

    -- bufferline
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
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
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
    if paccker_bootstrap then
      packer.sync()
    end
end)

return packer
