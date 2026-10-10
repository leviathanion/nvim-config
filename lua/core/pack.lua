local fn = vim.fn
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(install_path) then
    vim.notify("正在安装Lazy.nvim，请稍后...")
    local ok, output = pcall(fn.system, {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        install_path,
    })
    if not ok or vim.v.shell_error ~= 0 then
        vim.notify("安装 lazy.nvim 失败：\n" .. tostring(output), vim.log.levels.ERROR)
        return false
    end
end
vim.opt.rtp:prepend(install_path)
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("加载 lazy.nvim 失败：\n" .. tostring(lazy), vim.log.levels.ERROR)
    return false
end

local pluginlist = require("core.pluginlist")
local lazy_settings = require("configs.lazy")
lazy.setup(pluginlist, lazy_settings)
return true
