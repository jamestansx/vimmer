-- TODO: \v in searches for very magic
-- :h :DiffOrig

do -- https://github.com/mhinz/vim-galore#saner-command-line-history
    -- wildmenumode() ? <key> : <fallback>
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

-- split (un-join) line
vim.keymap.set("n", "gj", "i<c-j><esc>k$")

-- search within visual selection
vim.keymap.set("x", "/", "<esc>/\\%V")
vim.keymap.set("x", "?", "<esc>?\\%V")

-- TODO: join line remove spaces
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "gJ", "mzgJ`z")
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- home row
vim.keymap.set("", "H", "^")
vim.keymap.set("", "L", "$")

do -- smart jk (wrap)
    -- v:count || mode(1)[0:1] == 'no' ? <key> : g<key>
    local mov = function(key)
        local gkey = "g" .. key
        return function()
            local count = vim.v.count > 0
            local mode = vim.fn.mode(1):sub(1,2) == "no"
            return (count or mode) and key or gkey
        end
    end

    vim.keymap.set({ "n", "x" }, "j", mov("j"), { expr = true })
    vim.keymap.set({ "n", "x" }, "k", mov("k"), { expr = true })
end

-- select last inserted text
vim.keymap.set("n", "gV", "`[v`]")

-- yank/paste/delete
vim.keymap.set("x", "Y", '"+y')
vim.keymap.set("x", "y", "zy")
vim.keymap.set("n", "p", "zp")
vim.keymap.set("n", "P", "zP")
vim.keymap.set("x", "x", '"_d')

do -- block edit
    -- mode() =~ #'[vV]' ? '<c-v>^o^I' : 'I'
    -- mode() =~ #'[vV]' ? '<c-v>0o$A' : 'A'
    local block = function(key, bot, top)
        local bkey = ("<c-v>%so%s%s"):format(bot, top, key)
        return function()
            local mode = vim.fn.mode(1):sub(0,1):lower() == "v"
            return mode and bkey or key
        end
    end

    vim.keymap.set("x", "I", block("I", "^", "^"), { expr = true })
    vim.keymap.set("x", "A", block("A", "0", "$"), { expr = true })
end
