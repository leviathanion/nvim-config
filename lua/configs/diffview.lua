local M = {}

function M.config()
  local ok, diffview = pcall(require, "diffview")
  if not ok then
    vim.notify("没有找到 diffview")
    return
  end

  local actions = require("diffview.actions")

  diffview.setup({
    enhanced_diff_hl = true,
    view = {
      default = {
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        disable_diagnostics = true,
        winbar_info = true,
      },
    },
    keymaps = {
      view = {
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Focus changed files" } },
        { "n", "<localleader>b", actions.toggle_files, { desc = "Toggle changed files" } },
      },
      file_panel = {
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Focus changed files" } },
        { "n", "<localleader>b", actions.toggle_files, { desc = "Toggle changed files" } },
      },
      file_history_panel = {
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Focus history files" } },
        { "n", "<localleader>b", actions.toggle_files, { desc = "Toggle history files" } },
      },
    },
  })
end

return M
