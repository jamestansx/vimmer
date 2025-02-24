local analysis_excluded_folders, flutter_sdk_root
local dart_bin = "dart"

if vim.fn.executable("fvm") == 1 then
    local fvm_dir = vim.fs.find(".fvm", { limit = 1, type = "directory" })[1]

    if fvm_dir then
        flutter_sdk_root = vim.uv.fs_realpath(table.concat({ fvm_dir, "flutter_sdk" }, "/"))
        dart_bin = table.concat({ flutter_sdk_root, "bin", "dart" }, "/")
    end
elseif vim.fn.executable("flutter") == 1 then
    flutter_sdk_root = vim.fn.fnamemodify(vim.fn.exepath("flutter"), ":p:h:h")
    dart_bin = table.concat({ flutter_sdk_root, "bin", "dart" }, "/")
end

if flutter_sdk_root then
    analysis_excluded_folders = {
        table.concat({ flutter_sdk_root, "packages" }, "/"),
        table.concat({ flutter_sdk_root, ".pub-cache" }, "/"),
    }
end

vim.lsp.config["dartls"] = {
    cmd = { dart_bin, "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    root_markers = { "pubspec.yaml" },
    single_file_support = true,
    settings = {
        ["dart"] = {
            completeFunctionCalls = true,
            showTodos = false,
            updateImportsOnRename = true,
            analysisExcludedFolders = analysis_excluded_folders,
        },
    },
    init_options = {
        closingLabels = true,
        flutterOutline = true,
        outline = true,
        onlyAnalyzeProjectsWithOpenFiles = true,
        suggestFromUnimportedLibraries = true,
    },
}
