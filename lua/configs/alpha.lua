local M = {}
function M.config()
    -- alpha config
    local status, alpha = pcall(require, "alpha")
    if not status then
        vim.notify("没有找到 alpha")
        return
    end
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.header.val = {
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⠏⠵⠿⠿⠟⠋⠀⠁⢀⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡆⢣⣀⠰⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣿⣴⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⡿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⢿⡯⢸⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣟⣡⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡂⠀⠀⠀⠀⠀⠀⣠⣤⣄⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠐⠲⣿⣿⣟⣽⣾⣿⣿⠃⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⡿⣣⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⢌⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]]
    }
    dashboard.section.header.opts.hl = "Type"
    dashboard.section.buttons.val = {
        dashboard.button("SPC c n", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("SPC f f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("SPC f r", "  Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("SPC f g", "  Find word", ":Telescope live_grep<CR>"),
        dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
    }
    local function footer()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return "   Have Fun with neovim"
            .. "   v"
            .. vim.version().major
            .. "."
            .. vim.version().minor
            .. "."
            .. vim.version().patch
            .. "   "
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
    end
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "Function"
    local head_butt_padding = 1
    local occu_height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val + head_butt_padding
    local header_padding = math.max(0, math.ceil((vim.fn.winheight("$") - occu_height) * 0.25))

    dashboard.config.layout = {
        { type = "padding", val = header_padding },
        dashboard.section.header,
        { type = "padding", val = head_butt_padding },
        dashboard.section.buttons,
        dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
            dashboard.section.footer.val = footer()
            pcall(vim.cmd.AlphaRedraw)
        end,
    })
end

return M
