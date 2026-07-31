local M = {}

function M.config()
  local ok, noice = pcall(require, "noice")
  if not ok then
    vim.notify("没有找到 noice")
    return
  end

  noice.setup({
    messages = {
      view_search = false,
    },
    views = {
      notify = {
        replace = true,
      },
    },
    lsp = {
      progress = {
        throttle = 1000 / 30,
        view = "notify",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
  })
end

return M
