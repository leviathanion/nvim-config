local M = {}
function M.config()
    local status, lint = pcall(require, "lint")
    if not status then
        vim.notify("没有找到 nvim-lint")
        return
    end

    lint.linters_by_ft = {
        javascript = {
            "eslint_d"
        },
        typescript = {
            "eslint_d"
        },
        javascriptreact = {
            "eslint_d"
        },
        typescriptreact = {
            "eslint_d"
        },
        python = {
            "ruff"
        }
    }
end

return M
