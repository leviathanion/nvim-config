local M = {}

local signs = {
  add = { text = "┃" },
  change = { text = "┃" },
  delete = { text = "_" },
  topdelete = { text = "‾" },
  changedelete = { text = "~" },
  untracked = { text = "┆" },
}

function M.config()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    vim.notify("没有找到 gitsigns")
    return
  end

  gitsigns.setup({
    signs = signs,
    signs_staged = signs,
    current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
    preview_config = {
      border = "single",
    },
  })
end

return M
