-- NOTE: wrap treesitter.start to make it 'async'
-- otherwise, opening neorg file will hang on first load
vim.schedule(function()
    if vim.treesitter.language.add("norg") then
        vim.treesitter.start()
    end
end)
