local M = {}

function M.config()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    vim.notify("没有找到 lualine")
    return
  end

  lualine.setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_c = {},
    },
  })
end

return M
