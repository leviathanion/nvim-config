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
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      -- 官方 lsp_status 组件：显示当前 buffer 的 LSP + 进度 spinner；
      -- 内部监听 LspProgress 并自行 refresh（vim.ui.progress_status() 不会触发重绘，不可用）
      lualine_y = { "lsp_status" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_c = {},
    },
  })
end

return M
