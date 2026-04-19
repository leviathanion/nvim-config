vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

local function nmap(lhs, rhs, desc)
  map("n", lhs, rhs, { desc = desc, silent = true })
end

local function tmap(lhs, rhs, desc)
  map("t", lhs, rhs, { desc = desc, silent = true })
end

-- file tree
nmap("<A-m>", "<Cmd>NvimTreeToggle<CR>", "toggle file tree")

-- telescope
nmap("<leader>ff", function()
  require("telescope.builtin").find_files()
end, "find files")
nmap("<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, "grep")
nmap("<leader>fr", function()
  require("telescope.builtin").oldfiles()
end, "recent files")
nmap("<leader>fb", function()
  require("telescope.builtin").buffers()
end, "buffers")
nmap("<leader>fn", function()
  require("telescope").extensions.notify.notify()
end, "notify history")
nmap("<leader>ft", "<Cmd>TermSelect<CR>", "terminals")
nmap("<leader>fc", "<Cmd>NvimTreeFindFile<CR>", "reveal current file")

-- splits
nmap("<A-=>", "<C-w>+", "increase height")
nmap("<A-->", "<C-w>-", "decrease height")
nmap("<A-.>", "<C-w>>", "increase width")
nmap("<A-,>", "<C-w><", "decrease width")
nmap("<leader>sc", "<C-w>c", "close window")
nmap("<leader>so", "<C-w>o", "close other windows")
nmap("<leader>sh", "<Cmd>split<CR>", "split horizontal")
nmap("<leader>sv", "<Cmd>vsplit<CR>", "split vertical")

-- buffers
nmap("<C-h>", "<Cmd>BufferLineCyclePrev<CR>", "previous buffer")
nmap("<C-l>", "<Cmd>BufferLineCycleNext<CR>", "next buffer")

-- diagnostics and lsp
nmap("<leader>lo", vim.diagnostic.open_float, "open diagnostic")
nmap("<leader>lqc", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end, "current buffer diagnostics")
nmap("<leader>lqa", function()
  require("telescope.builtin").diagnostics()
end, "workspace diagnostics")
nmap("<leader>lr", vim.lsp.buf.rename, "rename symbol")
nmap("<leader>ld", vim.lsp.buf.hover, "hover")
nmap("<leader>lh", vim.lsp.buf.signature_help, "signature help")
nmap("<leader>laa", vim.lsp.buf.code_action, "code action")
nmap("<leader>lag", vim.lsp.buf.code_action, "code generate")
nmap("<leader>lfl", vim.lsp.buf.format, "lsp format")
nmap("<leader>lff", function()
  require("conform").format({ lsp_format = "fallback" })
end, "conform format")

nmap("<leader>lgD", vim.lsp.buf.declaration, "goto declaration")
nmap("<leader>lgdd", vim.lsp.buf.definition, "goto definition")
nmap("<leader>lgdt", vim.lsp.buf.type_definition, "goto type definition")
nmap("<leader>lgi", vim.lsp.buf.implementation, "goto implementation")
nmap("<leader>lgr", function()
  require("telescope.builtin").lsp_references()
end, "references")

nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
nmap("<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, "list workspace folders")

-- outline and terminal
nmap("<leader>ob", "<Cmd>AerialToggle<CR>", "toggle outline")
nmap("<leader>otn", "<Cmd>TermNew<CR>", "new terminal")
nmap("<leader>gtn", "<Cmd>ToggleTermSetName<CR>", "rename terminal")

-- git
nmap("[g", "<Cmd>Gitsigns prev_hunk<CR>", "previous hunk")
nmap("]g", "<Cmd>Gitsigns next_hunk<CR>", "next hunk")
nmap("<leader>hp", "<Cmd>Gitsigns preview_hunk<CR>", "preview hunk")
nmap("<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", "stage hunk")
nmap("<leader>hu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "undo stage hunk")
nmap("<leader>hd", "<Cmd>Gitsigns diffthis<CR>", "diff this")
nmap("<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", "reset hunk")
nmap("<leader>hb", "<Cmd>Gitsigns blame_line<CR>", "blame line")

-- docstring
nmap("<leader>gd", function()
  require("neogen").generate()
end, "generate docstring")

-- terminal
tmap("<Esc><Esc>", [[<C-\><C-n>]], "exit terminal mode")
