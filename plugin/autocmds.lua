local augroup = vim.api.nvim_create_augroup("me.autocmd", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.hl.on_yank({ timeout = 100 })
    end,
})

autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local excludes = { "gitcommit", "gitrebase", "help" }
        if vim.tbl_contains(excludes, vim.bo.ft) then return end

        -- resotre last cursor position
        local m = vim.api.nvim_buf_get_mark(0, '"')
        if m[1] > 0 and m[1] <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.api.nvim_win_set_cursor, 0, m)
        end
    end,
})

autocmd("BufNewFile", {
    group = augroup,
    callback = function()
        autocmd("BufWritePre", {
            group = augroup,
            buffer = 0,
            once = true,
            callback = function(args)
                -- ignore uri pattern
                if args.match:match("^%w://") then return end

                local file = vim.uv.fs_realpath(args.match) or args.match
                local dir = vim.fn.fnamemodify(file, ":p:h")
                vim.fn.mkdir(dir, "p")
            end,
        })
    end,
})
