-- 关闭 buffer（从 bufferline / tabline 上移除一个“标签页”），但保留窗口布局。
-- 原生 :bdelete 会顺带关掉显示该 buffer 的所有窗口（见 :h :bdelete），多窗口下布局会塌陷：
-- 这里先把窗口换成替代 buffer，再删除目标 buffer，语义上贴近 IDE 的“关闭标签页”。
local M = {}

local scratch_buf

local function is_listed(bufnr)
  return bufnr ~= nil and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

-- 没有其他 listed buffer 可以顶上时，用不占 tabline 的 scratch buffer 占住窗口
local function new_scratch()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    return scratch_buf
  end

  scratch_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[scratch_buf].bufhidden = "wipe"
  return scratch_buf
end

-- 窗口里换上的替代 buffer：该窗口的 alternate → buffer 列表中前一个 listed buffer → scratch
local function replacement(win, bufnr)
  local alt = vim.api.nvim_win_call(win, function()
    return vim.fn.bufnr("#")
  end)
  if alt ~= bufnr and is_listed(alt) then
    return alt
  end

  local prev
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf == bufnr then
      break
    end
    if is_listed(buf) then
      prev = buf
    end
  end

  return prev or new_scratch()
end

--- 删除 buffer，窗口布局保持不变。
--- 已修改且未保存的 buffer 会被拒绝：与 :bdelete 一样不静默丢改动，但不用 confirm 弹窗
---（cmdheight=0 + noice 的场景下弹窗体验更差）。
---@param bufnr integer|nil 目标 buffer，缺省为当前 buffer
function M.delete(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr

  if not is_listed(bufnr) then
    return
  end

  if vim.bo[bufnr].modified then
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
    vim.notify(("%s 未保存，已取消关闭"):format(name), vim.log.levels.WARN)
    return
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_set_buf(win, replacement(win, bufnr))
  end

  vim.api.nvim_buf_delete(bufnr, { force = false })
end

return M
