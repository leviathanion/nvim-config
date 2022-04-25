vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function mapkey(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap=true})
end

local function mapcmd(key, cmd)
    vim.api.nvim_set_keymap('n', key, ':'..cmd..'<cr>', {noremap=true})
end

local function maplua(key, txt)
    vim.api.nvim_set_keymap('n', key, ':lua '..txt..'<cr>', {noremap=true})
end

--  filetree
mapcmd('<A-m>', 'NvimTreeToggle')

-- f: telescope
mapcmd('<leader>ff', "Telescope find_files")
mapcmd('<leader>fg', "Telescope live_grep")
mapcmd('<leader>fb', "Telescope buffers")

-- s: split
mapkey('n', '<A-h>', '<c-w>h')
mapkey('n', '<A-j>', '<c-w>j')
mapkey('n', '<A-k>', '<c-w>k')
mapkey('n', '<A-l>', '<c-w>l')
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
-- g: goto
-- w: workspace
maplua('<leader>lo', 'vim.diagnostic.open_float()')
maplua('<leader>lq', 'vim.diagnostic.setloclist()')
maplua('<leader>ld', 'vim.lsp.buf.hover()')
maplua('<leader>lr', 'vim.lsp.buf.rename()')
maplua('<leader>lh', 'vim.lsp.buf.signature_help()')
maplua('<leader>la', 'vim.lsp.buf.code_action()')
maplua('<leader>lf', 'vim.lsp.buf.formatting()')
mapcmd('<leader>lb', 'SymbolsOutline')

maplua('<leader>gD', 'vim.lsp.buf.declaration()')
maplua('<leader>gd', 'vim.lsp.buf.definition()')
maplua('<leader>gt', 'vim.lsp.buf.type_definition()')
maplua('<leader>gi', 'vim.lsp.buf.implementation()')
maplua('<leader>gp', 'vim.diagnostic.goto_prev()')
maplua('<leader>gn', 'vim.diagnostic.goto_next()')
maplua('<leader>gr', 'vim.lsp.buf.references()')

maplua('<leader>wa', 'vim.lsp.buf.add_workspace_folder()')
maplua('<leader>wr', 'vim.lsp.buf.remove_workspace_folder()')
maplua('<leader>wl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')

-- toggleterm
mapcmd('<C-A-t>', 'ToggleTerm direction=float')
mapkey('t', '<esc>', [[<C-\><C-n>]])
