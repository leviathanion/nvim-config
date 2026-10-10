local M = {}
function M.config()
  local notify_opts = {
    -- 最大宽度
    max_width = 50,
    -- 渲染器
    render = "wrapped-compact",
  }

  -- 如果是透明背景，则需要设置背景色
  if vim.g.background_transparency then
    notify_opts.background_colour = "#ffffff"
  end

  local status, _ = pcall(require, "notify")
  if not status then
    vim.notify("没有找到 notify")
    return
  end
  vim.notify = require("notify")

  vim.notify.setup(notify_opts)

  local notify_keymaps = vim.api.nvim_create_augroup("notifyWindowKeymaps", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = notify_keymaps,
    pattern = "notify",
    callback = function(args)
      vim.keymap.set("n", "q", "<Cmd>close<CR>", {
        buffer = args.buf,
        silent = true,
        desc = "关闭通知窗口",
      })
    end,
  })
end

return M
