local M = {}

function M.config()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if not ok then
    vim.notify("没有找到 nvim-autopairs")
    return
  end

  autopairs.setup()
end

return M
