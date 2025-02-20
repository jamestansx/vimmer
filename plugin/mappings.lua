do -- https://github.com/mhinz/vim-galore#saner-command-line-history
    local nav_hist = function(key, fallback)
        return function()
            return vim.fn.wildmenumode() == 1 and key or fallback
        end
    end

    vim.keymap.set("c", "<c-p>", nav_hist("<c-p>", "<up>"), { expr = true })
    vim.keymap.set("c", "<c-n>", nav_hist("<c-n>", "<down>"), { expr = true })
end

-- center search result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "*", "*zzzv")
vim.keymap.set("n", "#", "#zzzv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "gJ", "mzgJ`z")
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- home row
vim.keymap.set("", "H", "^")
vim.keymap.set("", "L", "$")

do -- smart jk (wrap)
    local mov = function(key)
        local gkey = "g" .. key
        return function()
            local count = vim.v.count > 0
            local mode = vim.fn.mode(1):sub(0,1) == "no"
            return (count or mode) and key or gkey
        end
    end

    vim.keymap.set({ "n", "x" }, "j", mov("j"), { expr = true })
    vim.keymap.set({ "n", "x" }, "k", mov("k"), { expr = true })
end

-- select last inserted text
vim.keymap.set("n", "gV", "`[v`]")

-- yank/paste
vim.keymap.set("x", "Y", '"+y')
