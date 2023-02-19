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
        vim.lsp.buf.format()
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

autocmd({ "InsertLeave", "BufLeave" }, {
    group = myAutoGroup,
    pattern = "*",
    callback = function()
        vim.api.nvim_command("silent !fcitx5-remote -c")
    end,
})
