local user_settings = require("core.options")
local lazy_settings = {
    git = {
        default_url_format = user_settings.global_options.useMirror and "https://github.leviathanion.workers.dev/%s"
            or "https://github.com/%s.git",
    },
}
return lazy_settings
