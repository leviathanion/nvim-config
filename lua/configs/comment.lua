local M = {}

local mappings = {
  line = "<leader>lcl",
  block = "<leader>lcb",
}

M.keys = {
  { mappings.line, mode = { "n", "x" } },
  { mappings.block, mode = { "n", "x" } },
}

function M.config()
  local ok, comment = pcall(require, "Comment")
  if not ok then
    vim.notify("没有找到 Comment")
    return
  end

  comment.setup({
    toggler = {
      line = mappings.line,
      block = mappings.block,
    },
    opleader = {
      line = mappings.line,
      block = mappings.block,
    },
    mappings = {
      basic = true,
      extra = false,
    },
  })
end

return M
