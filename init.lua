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
require("me.luarocks").setup()
