local M = {}

function M.config()
  local ok, noice = pcall(require, "noice")
  if not ok then
    vim.notify("没有找到 noice")
    return
  end

  noice.setup({
    -- Noice owns only the floating command-line surface.
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
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
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
        ["vim.lsp.util.stylize_markdown"] = false,
        ["cmp.entry.get_documentation"] = false,
      },
    },
  })
end

return M
