local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
    clear = true,
})

local lspFormatGrop = vim.api.nvim_create_augroup("lspFormatGrop", {
    clear = false,
})

local autocmd = vim.api.nvim_create_autocmd

-- -- nvim-tree 自动关闭
-- autocmd("BufEnter", {
--   nested = true,
--   group = myAutoGroup,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("") ~= nil then
--       vim.cmd("quit")
--     end
--   end,
-- })


-- 保存时自动格式化
autocmd("BufWritePre", {
    group = lspFormatGrop,
    pattern = { "*.lua", "*.py", "*.sh" },
    callback = function()
        local buf_clients = vim.lsp.get_clients()

        -- Check LSP clients that support formatting
        for _, client in pairs(buf_clients) do
            if client.supports_method('textDocument/formatting') then
                vim.lsp.buf.format()
                return
            end
        end

        -- Fallback on conform
        require('conform').format()
    end
})

-- 修改lua/plugins.lua 自动更新插件
autocmd("BufWritePost", {
    group = myAutoGroup,
    -- autocmd BufWritePost plugins.lua source <afile> | PackerSync
    callback = function()
        if vim.fn.expand("<afile>") == "lua/core/pluginlist.lua" then
            vim.api.nvim_command("source lua/core/pluginlist.lua")
            vim.api.nvim_command("Lazy sync")
        end
    end,
})


-- 用o换行不要延续注释
autocmd("BufEnter", {
    group = myAutoGroup,
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - "o" -- O and o, don't continue comments
            + "r" -- But do continue when pressing enter.
    end,
})

autocmd({ "InsertEnter" }, {
    group = myAutoGroup,
    pattern = { "*.md" },
    callback = function()
        vim.api.nvim_command("silent !fcitx5-remote -o")
    end,
})

autocmd({ "InsertLeave", "BufLeave" }, {
    group    = myAutoGroup,
    pattern  = "*",
    callback = function()
        vim.api.nvim_command("silent !fcitx5-remote -c")
    end,
})

autocmd({ "BufReadPost" }, {
    group = lspFormatGrop,
    callback = function()
        require("lint").try_lint()
    end,
})

autocmd("FileType", {
    -- This will make TS install parser for each new filetype you open.
    -- If you want only specific filetypes, change `{ "*" }` to a list
    -- of preferred filetypes (not languages, unlike `ensure_installed`).
    pattern = { "*" },
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not vim.treesitter.language.add(lang) then
            local available = vim.g.ts_available
                or require("nvim-treesitter").get_available()
            if not vim.g.ts_available then
                vim.g.ts_available = available
            end
            if vim.tbl_contains(available, lang) then
                require("nvim-treesitter").install(lang)
            end
        end

        if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
        end
    end,
})
