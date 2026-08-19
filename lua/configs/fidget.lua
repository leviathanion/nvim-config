local M = {}

function M.config()
  local ok, fidget = pcall(require, "fidget")
  if not ok then
    vim.notify("没有找到 fidget")
    return
  end

  fidget.setup({
    progress = {
      -- Poll slowly enough to hide sub-second tasks while retaining useful
      -- indexing/build progress. Completed-before-poll tasks are omitted.
      poll_rate = 2,
      ignore_done_already = true,
      display = {
        render_limit = 5,
        done_ttl = 2,
        skip_history = true,
      },
    },
    notification = {
      -- nvim-notify remains the sole vim.notify() backend.
      override_vim_notify = false,
    },
  })
end

return M
