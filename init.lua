pcall(vim.loader.enable, true)

do -- boostrap mini.deps
    local mini_path = ("%s/site/pack/deps/start/mini.deps"):format(vim.fn.stdpath("data"))
    if not vim.uv.fs_stat(mini_path) then
        vim.system({
            "git", "clone", "--filter=blob:none",
            "https://github.com/echasnovski/mini.deps", mini_path
        }):wait()
        vim.cmd("packadd mini.deps | helptags ALL")
    end
end

require("mini.deps").setup()

-- Not so important TODOs:
-- - colorscheme (I want a colorscheme that don't give me tons of colors)
-- - neorg (I need to learn it)
-- - multicursor/mini.align (multicursor is more flexible)
-- - dadbod (database plugin I really need)
-- - search n replace (wanna try grug-far)
-- - firenvim (for browser editing)
-- - dap.nvim (Do I do debugging in neovim or external UI?)
-- - harpoon (so far I don't find this plugin that useful)
