local M = {}

local limits = {
  bytes = 2 * 1024 * 1024,
  lines = 10000,
  line_length = 1000,
}

local disabled_features = {}

local function is_bigfile(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].bigfile == true
end

local function mark_bigfile(bufnr, reason)
  if is_bigfile(bufnr) then
    return
  end

  vim.b[bufnr].bigfile = true
  vim.b[bufnr].bigfile_reason = reason
end

local function detect_by_size(args)
  vim.b[args.buf].bigfile = nil
  vim.b[args.buf].bigfile_reason = nil

  if args.file == "" then
    return
  end

  local stat = vim.uv.fs_stat(args.file)
  if stat and stat.size >= limits.bytes then
    mark_bigfile(args.buf, ("size: %d bytes"):format(stat.size))
  end
end

local function detect_by_content(bufnr)
  if is_bigfile(bufnr) then
    return
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count >= limits.lines then
    mark_bigfile(bufnr, ("lines: %d"):format(line_count))
    return
  end

  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    if #line >= limits.line_length then
      mark_bigfile(bufnr, ("line length: %d bytes"):format(#line))
      return
    end
  end
end

local function set_manual_folds(bufnr)
  local state = disabled_features[bufnr]
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if state and not state.folds[winid] then
      state.folds[winid] = {
        method = vim.wo[winid].foldmethod,
        expr = vim.wo[winid].foldexpr,
      }
    end
    vim.api.nvim_set_option_value("foldmethod", "manual", { win = winid })
    vim.api.nvim_set_option_value("foldexpr", "0", { win = winid })
  end
end

local function restore_features(bufnr)
  local state = disabled_features[bufnr]
  if not state then
    return
  end

  for winid, folds in pairs(state.folds) do
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
      vim.wo[winid].foldmethod = folds.method
      vim.wo[winid].foldexpr = folds.expr
    end
  end
  vim.lsp.semantic_tokens.enable(state.semantic_tokens, { bufnr = bufnr })
  disabled_features[bufnr] = nil
end

local function apply_bigfile_mode(bufnr)
  if not is_bigfile(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  if not disabled_features[bufnr] then
    disabled_features[bufnr] = {
      folds = {},
      semantic_tokens = vim.lsp.semantic_tokens.is_enabled({ bufnr = bufnr }),
    }
  end

  vim.treesitter.stop(bufnr)
  vim.api.nvim_set_option_value("indentexpr", "", { buf = bufnr })
  vim.api.nvim_set_option_value("syntax", "", { buf = bufnr })
  set_manual_folds(bufnr)

  -- 仅作用于当前缓冲区，后续附加的客户端也遵循此状态。
  vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
end

function M.config()
  local group = vim.api.nvim_create_augroup("BigfileMode", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPre", {
    group = group,
    callback = detect_by_size,
  })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(args)
      detect_by_content(args.buf)
      if not is_bigfile(args.buf) then
        -- 重读会重新触发 FileType，恢复语法、高亮和缩进。
        restore_features(args.buf)
        return
      end
      apply_bigfile_mode(args.buf)

      -- Later BufReadPost handlers may enable highlighting or indentation again.
      vim.schedule(function()
        apply_bigfile_mode(args.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      if is_bigfile(args.buf) then
        set_manual_folds(args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      disabled_features[args.buf] = nil
    end,
  })
end

return M
