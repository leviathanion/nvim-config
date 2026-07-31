local M = {}

function M.config()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then
    vim.notify("没有找到 bufferline")
    return
  end

  bufferline.setup({
    options = {
      numbers = "ordinal",
      buffer_close_icon = "󰅖",
      name_formatter = function(buf)
        if buf.name:match("%.md") then
          return vim.fn.fnamemodify(buf.name, ":t:r")
        end
      end,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diagnostics)
        local result = " "
        for severity, count in pairs(diagnostics) do
          local icon = severity == "error" and " " or (severity == "warning" and " " or "")
          result = result .. count .. icon
        end
        return result
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "left",
          highlights = "Directory",
        },
      },
      separator_style = "slant",
      hover = {
        enabled = true,
        reveal = { "close" },
      },
      sort_by = "insert_at_end",
    },
  })
end

return M
