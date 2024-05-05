local M = {}
function M.config()
    -- fidget config
    local status, conform = pcall(require, "conform")
    if not status then
        vim.notify("没有找到 conform")
        return
    end
    conform.setup {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            javascript = { { "prettierd", "prettier" } },
        }
    }
end

return M
