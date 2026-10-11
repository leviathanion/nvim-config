local M = {}

function M.config()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then
    vim.notify("没有找到 bufferline")
    return
  end

  -- 鼠标点击关闭与 <leader>bd 走同一条路径：删 buffer 但保留窗口布局
  local delete_buffer = require("core.buffers").delete

  bufferline.setup({
    options = {
      numbers = "ordinal",
      close_command = delete_buffer,
      right_mouse_command = delete_buffer,
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
          highlight = "Directory",
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
