local settings = {
    o = {
        termguicolors = true,
        encoding = "UTF-8",
        completeopt = "menu,menuone,noselect,noinsert",
        fileencoding = "utf-8",
        -- jkhl移动时光标周围保留8行
        scrolloff = 8,
        sidescrolloff = 8,
        -- 缩进四个空格等于一个Tab
        tabstop = 4,
        softtabstop = 4,
        shiftround = true,
        -- >> <<移动的长度
        shiftwidth = 4,
        -- 空格代替tab
        expandtab = true,
        -- 新行对齐当前行
        autoindent = true,
        smartindent = true,
        -- 搜索大小写不敏感，除非包含大写
        ignorecase = true,
        smartcase = true,
        -- 搜索时不高亮
        hlsearch = false,
        -- 边输入边搜索
        incsearch = true,
        -- 命令行高为1
        cmdheight = 1,
        -- 当文件被外部程序修改时，自动加载
        autoread = true,
        -- 鼠标支持
        mouse = "a",
        -- 禁止创建备份文件
        backup = false,
        writebackup = false,
        swapfile = false,
        -- updatetime
        updatetime = 300,
        -- timeoutlen设置
        timeoutlen = 500,
        -- split窗口从下边和右边出来
        splitright = true,
        splitbelow = true,
        -- 不显示可见字符
        list = false,
        -- 补全增强
        wildmenu = true,
        -- 补全最多显示10行
        pumheight = 10,
        -- 永远显示tabline
        showtabline = 2,
        -- 使用增强状态栏插件后不再需要vim的模式提示
        showmode = false,
        -- 出现错误时发出声音和闪烁
        errorbells = true,
		visualbell = true,
    },


    wo = {
        -- 使用相对行号
        number = true,
        relativenumber = true,
        -- 高亮所在行
        cursorline = true,
        -- 显示左侧图标指示列
        signcolumn = "yes",
        -- 右侧参考线，超过表示代码太长了，考虑换行
        colorcolumn = "80",
    },

    bo = {

    },
    disable_builtin_plugins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
    },
    global_options = {
        useMirror = false,
        mirrorURL = "https://hub.fgit.gq/"
    }
}

local function load_options()
    for prefix, options in pairs(settings) do
        if prefix ~= "disable_builtin_plugins" and prefix ~= "global_options" then
            for key, value in pairs(options) do
                vim[prefix][key] = value
            end
        else if prefix ~= "global_options" then
                for _, plugin in pairs(options) do
                    vim.g["loaded_" .. plugin] = 1
                end
            end
        end
    end
end

load_options()

return settings
