local M = {}
function M.config()
  -- https://github.com/rcarriga/nvim-notify
  local notify_opts = {
    -- 动画样式
    -- fade_in_slide_out
    -- fade
    -- slide
    -- static
    stages = "fade_in_slide_out",
    -- 超时时间，默认 5s
    -- timeout = 10000,
    -- 最大宽度
    max_width = 50,
    -- 渲染器
    render = "wrapped-compact"

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

  -- 使用案例：
  -- 信息、级别、标题
  -- 级别有：info、warn、error、debug、trace
  -- 示例：
  -- vim.notify("hello world", "info", {title = "info"})

  -- 显示历史弹窗记录
end

return M
