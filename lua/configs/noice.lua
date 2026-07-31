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
    popupmenu = {
      enabled = false,
    },
    routes = {
      {
        filter = { event = "lsp", kind = "progress" },
        view = "notify",
        opts = {
          merge = true,
          replace = true,
        },
      },
    },
    lsp = {
      progress = {
        throttle = 100,
        view = "notify",
      },
      signature = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      },
    },
  })
end

return M
