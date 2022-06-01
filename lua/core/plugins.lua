local user_settings = require("core.options")
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
    user_settings.global_options.useMirror and "https://hub.fastgit.xyz/wbthomason/packer.nvim"
        or "https://github.com/wbthomason/packer.nvim",
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
         default_url_format = user_settings.global_options.useMirror and "https://hub.fastgit.xyz/%s" 
                or "https://github.com/%s",
    },
})

packer.startup(function()
    use 'wbthomason/packer.nvim'

    -- speed up startup
    use 'nathom/filetype.nvim'
    use 'lewis6991/impatient.nvim'

    --nvim icon
    use {
        'kyazdani42/nvim-web-devicons',
    }

    -- git
    use {
        'airblade/vim-gitgutter',
    }

    -- theme
    use {
        'navarasu/onedark.nvim'
    }

    use {
        'onsails/lspkind-nvim',
    }

    use {
        'dstein64/vim-startuptime',
        cmd = "StartupTime"
    }

    -- 通知弹窗美化
    use {
        'rcarriga/nvim-notify',
        after = {"nvim-web-devicons"},
        config = function()
            require("configs.nvim-notify").config()
        end,
    }

    -- bufferline
    use {
        'akinsho/bufferline.nvim',
        after = {"nvim-web-devicons"},
        config = function()
            require("configs.bufferline").config()
        end,
    }

    -- status line
    use {
        'nvim-lualine/lualine.nvim',
        after = {"nvim-web-devicons", "vim-gitgutter"},
        config = function()
            require("configs.lualine").config()
        end,
    }

    -- file tree
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {"NvimTreeToggle"},
        config = function()
            require("configs.nvim-tree").config()
        end,
    }

    -- tagbar
    use {
        'simrat39/symbols-outline.nvim',
        cmd = {"SymbolsOutline"},
        config = function()
            require("configs.symbols-outline").config()
        end,
    }

    -- toggleterm
    use {
        'akinsho/toggleterm.nvim',
        config = function()
            require("configs.toggleterm").config()
        end,
    }

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require("configs.treesitter").config()
        end,
    }

    -- file telescope
    use {
       'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'BurntSushi/ripgrep'},
            {'nvim-lua/popup.nvim'}
        },
        config = function()
            require("configs.telescope").config()
        end,
    }

    -- vim-sandwich
    use {
        'machakann/vim-sandwich',
        event = {"BufRead"},
    }

    -- indent info
    use {
        'lukas-reineke/indent-blankline.nvim',
        event = {"BufRead"},
        config = function()
            require("configs.indent-blankline").config()
        end,
    }

    -- copilot
    -- use 'github/copilot.nvim'

    -- lsp
    use {
        'williamboman/nvim-lsp-installer',
        requires = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'neovim/nvim-lspconfig'},
        },
        config = function()
            require("lsp.setup")
        end,
    }
    -- lsp进度提示
    use {
        'j-hui/fidget.nvim',
        after = {"nvim-lsp-installer"},
        config = function()
            require("configs.fidget").config()
        end
    }
 
    --completion
    use {
        'rafamadriz/friendly-snippets',
        event = { "InsertEnter", "CmdlineEnter" },
    }
    use{
        'hrsh7th/vim-vsnip',
        ptp = "viml",
        after = { "friendly-snippets" },
    }
    use {
        'hrsh7th/nvim-cmp',
        after = { "vim-vsnip", "lspkind-nvim" },
        config = function()
            require("configs.cmp").config()
        end
    }
    use {
        'hrsh7th/cmp-buffer',
        after = {"nvim-cmp"}
    }
    use {
        'hrsh7th/cmp-path',
        after = {"nvim-cmp"}
    }
    use {
        'hrsh7th/cmp-cmdline',
        after = {"nvim-cmp"}
    }
    use {
        'hrsh7th/cmp-nvim-lua',
        after = {"nvim-cmp"}
    }
    use {
        'hrsh7th/cmp-nvim-lsp-signature-help',
        after = {"nvim-cmp"}
    }
    -- latex support
    use {
        'kdheepak/cmp-latex-symbols',
        after = {"nvim-cmp"}
    }
    -- autopairs
    use {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require("configs.nvim-autopairs").config()
        end
    }


    if paccker_bootstrap then
      packer.sync()
    end
end)

return packer
