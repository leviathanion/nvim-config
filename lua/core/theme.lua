local status, onedark = pcall(require, "onedark")
if not status then
    vim.notify("没有找到 onedark")
    return
end
onedark.setup {
    style = 'deep'
}
onedark.load()
