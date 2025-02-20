vim.lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    single_file_support = true,
    capabilities = {
        experimental = {
            serverStatusNotification = true,
        },
    },
    before_init = function(init_params, config)
        if config.settings and config.settings["rust-analyzer"] then
            init_params.initializationOptions = config.settings["rust-analyzer"]
        end
    end,
}
