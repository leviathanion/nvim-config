require("core.options")
require("configs.bigfile").config()
require("core.keymaps")
-- 插件管理器不可用时保留基础编辑能力，避免后续插件配置产生连锁错误。
if not require("core.pack") then
    return
end
require("core.theme")
require("core.autocmds")
