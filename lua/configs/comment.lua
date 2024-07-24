local M = {}
function M.config()
    -- Comment config
    local status, Comment = pcall(require, "Comment")
    if not status then
        vim.notify("没有找到 Comment")
        return
    end
    Comment.setup {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = '<leader>lcl',
            ---Block-comment toggle keymap
            block = '<leader>lcb',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = '<leader>lcl',
            ---Block-comment keymap
            block = '<leader>lcb',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = '<leader>lclO',
            ---Add comment on the line below
            below = '<leader>lclo',
            ---Add comment at the end of line
            eol = '<leader>lclA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = false,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
    }
end

return M
