local M = {}

local limits = {
  bytes = 2 * 1024 * 1024,
  lines = 10000,
  line_length = 1000,
}

local function is_bigfile(bufnr)
  return vim.b[bufnr].bigfile == true
end

local function mark_bigfile(bufnr, reason)
  if is_bigfile(bufnr) then
    return
  end

  vim.b[bufnr].bigfile = true
  vim.b[bufnr].bigfile_reason = reason
end

local function detect_by_size(args)
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
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_set_option_value("foldmethod", "manual", { win = winid })
    vim.api.nvim_set_option_value("foldexpr", "0", { win = winid })
  end
end

local function disable_semantic_tokens(bufnr, client_id)
  vim.lsp.semantic_tokens.enable(false, {
    bufnr = bufnr,
    client_id = client_id,
  })
end

local function apply_bigfile_mode(bufnr)
  if
    not is_bigfile(bufnr)
    or not vim.api.nvim_buf_is_valid(bufnr)
    or not vim.api.nvim_buf_is_loaded(bufnr)
  then
    return
  end

  vim.treesitter.stop(bufnr)
  vim.api.nvim_set_option_value("indentexpr", "", { buf = bufnr })
  vim.api.nvim_set_option_value("syntax", "", { buf = bufnr })
  set_manual_folds(bufnr)

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    disable_semantic_tokens(bufnr, client.id)
  end
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

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      if not is_bigfile(args.buf) then
        return
      end

      vim.schedule(function()
        if is_bigfile(args.buf) and vim.api.nvim_buf_is_valid(args.buf) then
          disable_semantic_tokens(args.buf, args.data.client_id)
        end
      end)
    end,
  })
end

return M
