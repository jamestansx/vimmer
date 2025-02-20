local rocks = require("me.luarocks")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    vim.cmd("packadd! cfilter")
    vim.cmd("packadd! termdebug")
    vim.cmd("colorscheme quiet")
end)
