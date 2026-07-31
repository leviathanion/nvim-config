local M = {}

function M.config()
  local ok, indent_blankline = pcall(require, "ibl")
  if not ok then
    vim.notify("没有找到 indent_blankline")
    return
  end

  indent_blankline.setup({
    scope = {
      enabled = false,
    },
  })

  local hooks_ok, hooks = pcall(require, "ibl.hooks")
  if hooks_ok then
    hooks.register(hooks.type.ACTIVE, function(bufnr)
      return not vim.b[bufnr].bigfile
    end)
  end
end

return M
