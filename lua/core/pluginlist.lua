local pluginlist = {
  {
    "navarasu/onedark.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    -- vim.lsp.enable() installs global FileType handlers; register them before
    -- any buffer event instead of relying on Lazy's event replay.
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim" },
    },
    config = function()
      require("configs.nvim-lspconfig").config()
    end,
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.gitsigns").config()
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("configs.diffview").config()
    end,
  },

  {
    "goolord/alpha-nvim",
    config = function()
      require("configs.alpha").config()
    end,
  },

  -- 非功能依赖而是顺序保证：mason.setup() 必须先于 vim.lsp.enable() 运行，
  -- 将 ~/.local/share/nvim/mason/bin 前置到 PATH，server 二进制才能按名字解析；
  -- 因此它随 nvim-lspconfig（lazy=false）常驻加载，无需也不能懒加载。
  {
    "mason-org/mason.nvim",
    config = function()
      require("configs.mason").config()
    end,
  },

  -- 快捷键展示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("configs.which-key").config()
    end,
  },

  -- Noice is intentionally limited to command-line presentation. Messages,
  -- notifications, completion, and LSP UI are owned by dedicated components.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("configs.noice").config()
    end,
  },

  -- Explicit notifications; ordinary messages stay in Neovim's native UI.
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
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
    lazy = false,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    config = function()
      require("configs.nvim-tree").config()
    end,
  },

  -- tagbar
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    config = function()
      require("configs.aerial").config()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
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
    build = ":TSUpdate",
    branch = "main",
    config = function()
      require("configs.nvim-treesitter").config()
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("configs.nvim-treesitter-context").config()
        end,
      },
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
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configs.indent-blankline").config()
    end,
  },

  --completion
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*",
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
    end,
  },

  -- docstring
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cd",
        function()
          require("neogen").generate()
        end,
        desc = "generate docstring",
      },
    },
    config = function()
      require("neogen").setup({})
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },

  --linter
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configs.nvim-lint").config()
    end,
  },

  --formater
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("configs.conform").config()
    end,
  },

  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    ft = { "markdown" },
    config = function()
      require("livepreview.config").set({
        picker = "telescope",
        sync_scroll = true,
      })
    end,
  },
}
return pluginlist
