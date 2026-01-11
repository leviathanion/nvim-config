local user_settings = require("core.options")
local M = {}
function M.config()
    local status, nvim_treesitter = pcall(require, "nvim-treesitter")
    if not status then
        vim.notify("没有找到 nvim-treesitter")
        return
    end
    -- nvim-treesitter config
    if user_settings.global_options.useMirror then
        for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
            config.install_info.url = config.install_info.url:gsub("https://github.com/",
                user_settings.global_options.useMirror)
        end
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*", -- 可调整为特定 filetype
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })

    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldlevel  = 99 -- 默认不折叠
end

return M
