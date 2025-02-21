local lsp = require("me.lsp")
local command = vim.api.nvim_create_user_command

command("LspRestart", function(kwargs)
    lsp.restart(kwargs.fargs, kwargs.bang)
end, { nargs = "*", complete = lsp.complete_client_names, bang = true })

command("LspStop", function(kwargs)
    lsp.stop(kwargs.fargs, kwargs.bang)
end, { nargs = "*", complete = lsp.complete_client_names, bang = true })

command("LspInfo", function()
    vim.cmd("botright checkhealth vim.lsp")
end, {})

command("LspLog", lsp.log_open, {})
command("LspClean", lsp.log_clear, {})
