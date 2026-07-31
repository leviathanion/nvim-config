local M = {}

function M.config()
  local ok, mason = pcall(require, "mason")
  if not ok then
    vim.notify("没有找到 mason")
    return
  end

  mason.setup()
end

return M
