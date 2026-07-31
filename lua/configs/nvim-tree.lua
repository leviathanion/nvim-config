local M = {}

function M.config()
  local ok, nvim_tree = pcall(require, "nvim-tree")
  if not ok then
    vim.notify("没有找到 nvim-tree")
    return
  end

  nvim_tree.setup({
    renderer = {
      group_empty = true,
    },
  })
end

return M
