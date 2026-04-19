local pluginlist = {
  {
    "navarasu/onedark.nvim"
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.nvim-lspconfig").config()
    end
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime"
  },

  {
    "LunarVim/bigfile.nvim"
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.gitsigns").config()
    end
  },

  {
    "goolord/alpha-nvim",
    config = function()
      require("configs.alpha").config()
    end
  },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    config = function()
      require("configs.mason").config()
    end,
  },

  -- 快捷键展示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    config = function()
      require("configs.which-key").config()
    end
  },

  -- 通知弹窗美化
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("configs.noice").config()
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      -- 使用新窗口接管原有的viml.ui选择窗口
      "stevearc/dressing.nvim",
    }
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    config = function()
      require("configs.nvim-notify").config()
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("configs.bufferline").config()
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "lewis6991/gitsigns.nvim" },
    },
    config = function()
      require("configs.lualine").config()
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    config = function()
      require("configs.nvim-tree").config()
    end,
  },

  -- tagbar
  {
    'stevearc/aerial.nvim',
    cmd = { "AerialToggle" },
    config = function()
      require("configs.aerial").config()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },

  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("configs.toggleterm").config()
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      require("configs.nvim-treesitter").config()
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context" },
    },
  },

  -- file telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("configs.telescope").config()
    end,
  },

  -- vim-sandwich
  {
    "machakann/vim-sandwich",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- indent info
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost" },
    config = function()
      require("configs.indent-blankline").config()
    end,
  },

  --completion
  {
    'saghen/blink.cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    version = '1.*',
    config = function()
      require("configs.blink-cmp").config()
    end,
  },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("configs.nvim-autopairs").config()
    end
  },

  {
    'numToStr/Comment.nvim',
    event = "InsertEnter",
    config = function()
      require("configs.comment").config()
    end
  },

  -- docstring
  {
    "danymat/neogen",
    event = "BufReadPost",
    config = function()
      require("neogen").setup {}
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    }
  },

  --linter
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configs.nvim-lint").config()
    end
  },

  --formater
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("configs.conform").config()
    end
  },


  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  }
}
return pluginlist
