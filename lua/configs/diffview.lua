local M = {}

function M.config()
  local ok, diffview = pcall(require, "diffview")
  if not ok then
    vim.notify("没有找到 diffview")
    return
  end

  diffview.setup({
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = "diff2_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        layout = "diff2_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
  })
end

return M
