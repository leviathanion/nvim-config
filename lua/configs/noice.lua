local M = {}

function M.config()
  local ok, noice = pcall(require, "noice")
  if not ok then
    vim.notify("没有找到 noice")
    return
  end

  noice.setup({
    -- 只使用浮动命令行，其他功能沿用现有配置。
    messages = {
      enabled = false,
    },
    popupmenu = {
      enabled = false,
    },
    notify = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = false,
      },
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      message = {
        enabled = false,
      },
    },
  })
end

return M
