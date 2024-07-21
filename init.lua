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

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
neovide_config()
require("core.options")
require("core.keymaps")
require("core.pack")
require("core.theme")
require("core.autocmds")
