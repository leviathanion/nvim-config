local M = {}
function M.config()
    -- nvim-treesitter config
    require'nvim-treesitter.configs'.setup {
        -- ensure_installed = "maintained", -- for installing all maintained parsers
        ensure_installed = { "c", "cpp", "rust", "lua", "python", "java", "go"}, -- for installing specific parsers
        sync_install = true, -- install synchronously
        ignore_install = { }, -- parsers to not install
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false, -- disable standard vim highlighting
        },
        -- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
        indent = {
            enable = true
        }
    }
end
return M
