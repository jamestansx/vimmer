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

-- yank/paste
vim.keymap.set("x", "Y", '"+y')
