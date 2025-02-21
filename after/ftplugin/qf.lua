local augroup = vim.api.nvim_create_augroup("me.qf", { clear = true })

vim.wo.relativenumber = false

vim.keymap.set("n", "q", "<cmd>bdelete<cr>", { buffer = 0, nowait = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    buffer = 0,
    nested = true,
    callback = function()
        if vim.fn.winnr("$") < 2 then
            vim.cmd("silent quit")
        end
    end,
})
