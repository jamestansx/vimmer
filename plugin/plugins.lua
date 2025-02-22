local rocks = require("me.luarocks")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    vim.cmd("packadd! cfilter")
    vim.cmd("packadd! termdebug")
    vim.cmd("colorscheme lunaperche")
end)

now(function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    add("justinmk/vim-dirvish")

    -- sort directories with dotfiles first
    vim.g.dirvish_mode = [[:sort | sort ,^.*[\/],]]

    -- required 'expr' to be true
    local eat_space = function(key)
        return function()
            local char = vim.fn.getchar(0)
            char = vim.fn.nr2char(char)
            return ("%s%s"):format(key, char:match("%s") and "" or char)
        end
    end

    local augroup = vim.api.nvim_create_augroup("me.dirvish", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "dirvish",
        callback = function(args)
            local opts = { buffer = args.buf, expr = true }

            vim.keymap.set("ca", "e", eat_space("e %"), opts)
            vim.keymap.set("ca", "mkdir", eat_space("!mkdir -p %"), opts)
        end,
    })
end)

-- lspconfig
now(function()
    local augroup = vim.api.nvim_create_augroup("me.lsp", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(args)
            local buf = args.buf

            vim.keymap.set("n", "grq", vim.diagnostic.setqflist, { buffer = buf })
            vim.keymap.set("n", "<bs>", function()
                local enabled = not vim.lsp.inlay_hint.is_enabled()
                vim.lsp.inlay_hint.enable(enabled)
            end, { buffer = buf })
        end,
    })

    vim.lsp.log.set_format_func(vim.inspect)
    vim.lsp.log.set_level(vim.lsp.log.levels.ERROR)

    vim.lsp.config("*", {
        root_markers = { ".git" },
    })

    vim.lsp.enable("rust_analyzer")
end)
