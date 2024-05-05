local M = {}
function M.config()
    local user_settings = require("core.options")
    local status_mason, mason = pcall(require, "mason")
    if not status_mason then
        vim.notify("没有找到 mason")
        return
    end
    mason.setup({
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗"
            }
        },
        github = {
            -- The template URL to use when downloading assets from GitHub.
            -- The placeholders are the following (in order):
            -- 1. The repository (e.g. "rust-lang/rust-analyzer")
            -- 2. The release version (e.g. "v0.3.0")
            -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
            download_url_template = user_settings.global_options.useMirror and
                user_settings.global_options.useMirror .. "%s/release/download/%s/%s"
                or "https://github.com/%s/releases/download/%s/%s"
        },
    })
end

return M
