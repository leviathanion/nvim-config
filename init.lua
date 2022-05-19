local neovide_config = function()
	vim.cmd([[set guifont=FiraCode\ NF:h13]])
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_no_idle = true
	vim.g.neovide_cursor_animation_length = 0.03
	vim.g.neovide_cursor_trail_length = 0.05
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_vfx_opacity = 200.0
	vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
	vim.g.neovide_cursor_vfx_particle_speed = 20.0
	vim.g.neovide_cursor_vfx_particle_density = 5.0
end

local load_core = function()
    neovide_config()
    -- 基础配置
    require("core.options")
    -- 快捷键映射
    require("core.keymaps")
    -- 插件管理
    require("core.plugins")
    require("impatient")
    -- 主题配置
    require("core.theme")

    require("configs.cmp").config()
    require("configs.nvim-tree").config()
    require("configs.symbols-outline").config()
    require("configs.lualine").config()
    require("configs.treesitter").config()
    require("configs.bufferline").config()
    require("configs.toggleterm").config()
    require("configs.indent-blankline").config()
    require("configs.nvim-autopairs").config()
    require("configs.fidget").config()
    require("configs.nvim-notify").config()
    require("lsp.setup")
end

load_core()
