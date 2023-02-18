local fn = vim.fn
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_bootstrap
if not vim.loop.fs_stat(install_path) then
  vim.notify("正在安装Lazy.nvim，请稍后...")
  lazy_bootstrap = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)
-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify("没有安装 lazy.nvim")
  return
end

local pluginlist = require("core.pluginlist")
local lazy_settings = require("configs.lazy")
lazy.setup(pluginlist,lazy_settings)
