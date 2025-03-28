vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function mapkey(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

local function mapcmd(key, cmd)
    vim.api.nvim_set_keymap('n', key, ':' .. cmd .. '<cr>', { noremap = true })
end

local function maplua(key, txt)
    vim.api.nvim_set_keymap('n', key, ':lua ' .. txt .. '<cr>', { noremap = true })
end

--  filetree
mapcmd('<A-m>', 'NvimTreeToggle')

-- f: telescope
maplua('<leader>ff', "require('telescope.builtin').find_files()")
maplua('<leader>fg', "require('telescope.builtin').live_grep()")
maplua('<leader>fr', "require('telescope.builtin').oldfiles()")
maplua('<leader>fb', "require('telescope.builtin').buffers()")
maplua('<leader>fn', "require('telescope').extensions.notify.notify()")


-- s: split
mapkey('n', '<A-=>', '<c-w>+')
mapkey('n', '<A-->', '<c-w>-')
mapkey('n', '<A-.>', '<c-w>>')
mapkey('n', '<A-,>', '<c-w><')
mapkey('n', '<leader>sc', '<c-w>c')
mapkey('n', '<leader>so', '<c-w>o')
mapcmd('<leader>sh', 'sp')
mapcmd('<leader>sv', 'vs')

-- bufferline 左右Tab切换
mapcmd('<C-h>', 'BufferLineCyclePrev<CR>')
mapcmd('<C-l>', 'BufferLineCycleNext<CR>')

-- l/g/w: language
-- l: general
-- lg: goto
-- w: workspace
-- o: open
maplua('<leader>lo', 'vim.diagnostic.open_float()')
maplua('<leader>lqc', 'require("telescope.builtin").diagnostics{bufnr=0}')
maplua('<leader>lqa', 'require("telescope.builtin").diagnostics{}')
maplua('<leader>lr', 'vim.lsp.buf.rename()')
maplua('<leader>ld', 'vim.lsp.buf.hover()')
maplua('<leader>lh', 'vim.lsp.buf.signature_help()')
maplua('<leader>laa', 'vim.lsp.buf.code_action()')
maplua('<leader>lag', 'vim.lsp.buf.code_action()')
maplua('<leader>lfl', 'vim.lsp.buf.format()')
maplua('<leader>lff', 'require("conform").format()')

maplua('<leader>lgD', 'vim.lsp.buf.declaration()')
maplua('<leader>lgdd', 'vim.lsp.buf.definition()')
maplua('<leader>lgdt', 'vim.lsp.buf.type_definition()')
maplua('<leader>lgi', 'vim.lsp.buf.implementation()')
maplua('<leader>lgr', 'require("telescope.builtin").lsp_references{}')

maplua('<leader>wa', 'vim.lsp.buf.add_workspace_folder()')
maplua('<leader>wr', 'vim.lsp.buf.remove_workspace_folder()')
maplua('<leader>wl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')

mapcmd('<leader>ob', 'AerialToggle')
mapcmd('<leader>oc', 'Copilot panel')
mapcmd('<leader>oCc', 'ChatGPT')
mapcmd('<leader>oCp', 'ChatGPTActAs')

mapcmd('[g', 'Gitsigns prev_hunk')
mapcmd(']g', 'Gitsigns next_hunk')
mapcmd('<leader>hp', 'Gitsigns preview_hunk')
mapcmd('<leader>hs', 'Gitsigns stage_hunk')
mapcmd('<leader>hu', 'Gitsigns undo_stage_hunk')
mapcmd('<leader>hd', 'Gitsigns diffthis')
mapcmd('<leader>hr', 'Gitsigns reset_hunk')
mapcmd('<leader>hb', 'Gitsigns blame_line')


-- toggleterm
mapkey('t', '<esc>', [[<C-\><C-n>]])

-- g: generate
maplua('<leader>gd', "require('neogen').generate()")
