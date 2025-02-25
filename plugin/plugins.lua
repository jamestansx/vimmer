local rocks = require("me.luarocks")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    vim.cmd("packadd! cfilter")
    vim.cmd("packadd! termdebug")
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

    require("me.lsp.status").setup()

    vim.lsp.log.set_format_func(vim.inspect)
    vim.lsp.log.set_level(vim.lsp.log.levels.ERROR)

    vim.lsp.config("*", {
        root_markers = { ".git" },
    })

    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("tsserver")
    vim.lsp.enable("dartls")
end)

-- auto-completion
later(function()
    add({ source = "Saghen/blink.cmp", checkout = "v0.12.4" })

    require("blink.cmp").setup({
        keymap = {
            preset = "none",
            ["<c-n>"] = { "show", "select_next" },
            ["<c-p>"] = { "show", "select_prev" },
            ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<c-e>"] = { "hide", "fallback" },
            ["<c-y>"] = { "select_and_accept", "fallback" },
            ["<cr>"] = { "accept", "fallback" },
            ["<tab>"] = { "snippet_forward", "fallback" },
            ["<s-tab>"] = { "snippet_backward", "fallback" },
            ["<c-b>"] = { "scroll_documentation_up", "fallback" },
            ["<c-f>"] = { "scroll_documentation_down", "fallback" },
            ["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
        },
        cmdline = { enabled = false },
        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = { max_height = 5 },
            ghost_text = { enabled = true },
        },
        signature = {
            enabled = true,
            window = { show_documentation = false },
        },
    })
end)

-- formatting
later(function()
    add("stevearc/conform.nvim")

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    require("conform").setup({
        log_level = vim.log.levels.ERROR,
        formatters_by_ft = {
            dart = { "dart_format", lsp_format = "fallback" },
            rust = { "rustfmt" },
            ["_"] = { "trim_whitespace" },
        },
    })
end)

later(function()
    add({
        source = "ggandor/leap.nvim",
        depends = { "tpope/vim-repeat" },
    })

    local leap = require("leap")
    local user = require("leap.user")

    user.set_repeat_keys("<enter>", "<s-enter>", { relative_directions = true })
    leap.opts.equivalence_classes = { " \t\r\n", "({[", ")}]", "'\"`" }
    leap.opts.special_keys = {
        next_target = "<enter>",
        prev_target = "<s-enter>",
        next_group = "<space>",
        prev_group = "<s-space>",
    }

    vim.keymap.set({"n", "x", "o"}, "s", function() leap.leap({}) end)
    vim.keymap.set({"n", "x", "o"}, "S", function() leap.leap({ backward = true }) end)
    vim.keymap.set({"n", "x", "o"}, "gs", function() require("leap.remote").action() end)
    vim.keymap.set({"n", "x", "o"}, "gS", function() leap.leap({ target_windows = user.get_enterable_windows() }) end)

    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
end)
