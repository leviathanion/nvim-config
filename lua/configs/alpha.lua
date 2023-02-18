local M = {}
function M.config()
    -- alpha config
    local status, alpha = pcall(require, "alpha")
    if not status then
        vim.notify("没有找到 alpha")
        return
    end
    local dashboard = require'alpha.themes.dashboard'
    dashboard.section.header.val = {
        [[MMMMMMMMMMMMMMMMMWWWWWMW0kKKNMMMMMMMMMMM]],
        [[MMMMMMMMMMMMMMMWXkoodddl'.'oXMMMMMMMMMMM]],
        [[MMMMMMMMMMMMWXko;...   ....cxKWMMMMMMMMM]],
        [[MMMMMMMMMWWNk,.  .  .........lNMMMMMMMMM]],
        [[MMMMMMMMM0o:.     .........'.lNMMMMMMMMM]],
        [[MMMMMMMMNd. .. .  ....';;...;kNMMWWNNWMM]],
        [[MMMMMMMWk,...........,lxxocoKWWNNNNXXNWM]],
        [[MMMMMMMWk' .........,ckOkO0OXWNNNWWWWMMM]],
        [[MMMMMMMNO;.. .  ....,lO0OO0OKNNWWMMMMMMM]],
        [[MMMMMMWx'. .  . .:::clxkOOOOXWMMMMMMMMMM]],
        [[MMMMMWKo;..  .   .':loooxk0KNWMMMMMMMMMM]],
        [[MMMMMMWNN0o;...',;codxdd0XNMMMMMMMMMMMMM]],
        [[MMMMMMMMMMW0lldkkOOOOO00XK0XWMMMMMMMMMMM]],
        [[MMMMMMMMMWk;..';coxOO0KNXKXWMMMMMMMMMMMM]],
        [[MMMMMMMMXl..   ...';:lkXKKNMMMMMMMMMMMMM]],
        [[MMMMMMM0;... .........,oxOWMMMMMMMMMMMMM]],
        [[MMMN0ddxxxxxxxxxxxxxxxxxkkkkOKWMMMMMMMMM]],
    }
    dashboard.section.buttons.val = {
        dashboard.button( "SPC c n", "  New file" , ":ene <BAR> startinsert <CR>"),
        dashboard.button( "SPC f f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button( "SPC f r", "  Recent"   , ":Telescope oldfiles<CR>"),
        dashboard.button( "SPC f g", "  Find word", ":Telescope live_grep<CR>"),
        dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),
    }
    local handle = io.popen('fortune')
    local fortune = handle:read("*a")
    handle:close()
    dashboard.section.footer.val = fortune
    alpha.setup ( dashboard.opts )
end
return M
