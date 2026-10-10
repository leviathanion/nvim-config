local M = {}

function M.project_root()
    local cwd = vim.fn.getcwd()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo[bufnr].buftype ~= "" or filename == "" or filename:match("^%w+://") then
        return cwd
    end

    local root
    local function consider(path)
        if type(path) ~= "string" or path == "" then
            return
        end
        path = vim.fs.normalize(path)
        -- 多根工作区优先选当前文件所属的最深根，避免把同名前缀目录误判为子目录。
        if vim.fs.relpath(path, filename) and (not root or #path > #root) then
            root = path
        end
    end

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        consider(client.config.root_dir)
        for _, folder in ipairs(client.workspace_folders or {}) do
            if type(folder.uri) == "string" and folder.uri:match("^file:") then
                consider(vim.uri_to_fname(folder.uri))
            end
        end
    end

    return root or vim.fs.root(vim.fs.dirname(filename), ".git") or cwd
end

function M.config()
    local status, telescope = pcall(require, "telescope")
    if not status then
        vim.notify("没有找到 telescope")
        return
    end
    telescope.setup {
    }
    telescope.load_extension("live_grep_args")
end

return M
