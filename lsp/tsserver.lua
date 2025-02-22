vim.lsp.config["tsserver"] = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { "package.json", "tsconfig.json" },
    single_file_support = true,
    init_options = { hostInfo = "neovim" },
}
