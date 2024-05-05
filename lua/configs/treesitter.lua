local user_settings = require("core.options")
local M = {}
function M.config()
    local status, treesitter = pcall(require, "nvim-treesitter")
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
    treesitter.setup {
        -- ensure_installed = "maintained", -- for installing all maintained parsers
        ensure_installed = {}, -- for installing specific parsers
        sync_install = true,   -- install synchronously
        ignore_install = {},   -- parsers to not install
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true, -- disable standard vim highlighting
        },
        -- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
        indent = {
            enable = false
        },
        -- 启用增量选择
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
                scope_incremental = '<TAB>',
            }
        }
    }
    -- 开启 Folding
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
    -- 默认不要折叠
    -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
    vim.wo.foldlevel = 99
end

return M
