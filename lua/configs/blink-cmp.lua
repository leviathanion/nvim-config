local M = {}
function M.config()
    local status, blink = pcall(require, "blink.cmp")
    if not status then
        vim.notify("没有找到 blink.cmp")
        return
    end
    blink.setup {
        keymap = {
            preset = 'none',
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<Enter>'] = { 'select_and_accept', 'fallback' },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

            ['<Tab>'] = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        sources = {
            default = { 'lsp', 'buffer', 'snippets', 'path', 'omni' }
        },
        snippets = { preset = 'luasnip' },
        signature = { enabled = true },
        completion = {
            list = {
                -- Maximum number of items to display
                max_items = 200,

                selection = {
                    -- When `true`, will automatically select the first item in the completion list
                    preselect = true,
                    -- preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end,

                    -- When `true`, inserts the completion item automatically when selecting it
                    -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
                    -- which will both undo the selection and hide the completion menu
                    auto_insert = false,
                    -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
                },

                cycle = {
                    -- When `true`, calling `select_next` at the _bottom_ of the completion list
                    -- will select the _first_ completion item.
                    from_bottom = true,
                    -- When `true`, calling `select_prev` at the _top_ of the completion list
                    -- will select the _last_ completion item.
                    from_top = true,
                },
            },
        },
        cmdline = {
            completion = {
                list = {
                    selection = {
                        -- When `true`, will automatically select the first item in the completion list
                        preselect = true,
                        -- When `true`, inserts the completion item automatically when selecting it
                        auto_insert = true,
                    },
                },
                menu = {
                    auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ':'
                        -- enable for inputs as well, with:
                        -- or vim.fn.getcmdtype() == '@'
                    end,
                },
            }
        }
    }
end

return M
