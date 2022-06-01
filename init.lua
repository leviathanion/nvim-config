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

-- 基础配置
require("configs.impatient").config()
require("core.theme")
local async
async =
    vim.loop.new_async(
        vim.schedule_wrap(
            function()
                neovide_config()
                require("core.options")
                -- 快捷键映射
                require("core.keymaps")
                -- 插件管理
                require("core.plugins")
                async:close()
            end
        )
    )
async:send()
