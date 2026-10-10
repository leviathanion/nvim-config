local M = {}
function M.config()
  local status, toggleterm = pcall(require, "toggleterm")
  if not status then
    vim.notify("没有找到 toggleterm")
    return
  end
  toggleterm.setup {
    size = 20,
    open_mapping = [[<c-\>]],
    shading_factor = 2,
    insert_mappings = false,
    direction = "float",
    float_opts = {
      border = "double",
    },
  }
end

return M
