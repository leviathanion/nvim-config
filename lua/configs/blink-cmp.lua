local M = {}
function M.config()
  local status, blink = pcall(require, "blink.cmp")
  if not status then
    vim.notify("没有找到 blink.cmp")
    return
  end

  blink.setup {
    enabled = function()
      return not vim.b.bigfile
    end,
    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    sources = {
      default = { 'lsp', 'buffer', 'snippets', 'path', 'omni' },
      providers = {
        cmdline = {
          min_keyword_length = function(ctx)
            if ctx.mode == 'cmdline' and not ctx.line:find('%s') then
              return ctx.trigger and ctx.trigger.initial_kind == 'manual' and 0 or 3
            end
            return 0
          end,
        },
      },
    },
    signature = { enabled = true },
    completion = {
      list = {
        selection = {
          auto_insert = false,
        },
      },
    },
    cmdline = {
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        if type == ':' or type == '@' then
          return { 'cmdline' }
        end
        return {}
      end,
      keymap = {
        ['<CR>'] = { 'select_accept_and_enter', 'fallback' },
      },
      completion = {
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ':'
          end,
        },
      }
    }
  }
end

return M
