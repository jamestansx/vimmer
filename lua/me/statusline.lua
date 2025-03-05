local M = {}
local state = {
    diagcount = {},
    lsp_attached = false,
}

-- TODO: check truncate condition on 'VimResized' event or within function itself
local config = {
    lsp_icon = "● ",
    diagnostic = {
        { name = "ERROR", sign = "E", hl = "DiagnosticSignError" },
        { name = "WARN", sign = "W", hl = "DiagnosticSignWarn" },
        { name = "INFO", sign = "I", hl = "DiagnosticSignInfo" },
        { name = "HINT", sign = "H", hl = "DiagnosticSignHint" },
    },
}

M.gitinfo = function()
    local summary = vim.b.minigit_summary_string or ""
    if summary == "" then return "" end

    return (" %s"):format(summary)
end

-- "E1 W1 I1"
M.diagcount = function()
    local diagcount = state.diagcount[vim.api.nvim_get_current_buf()]
    return diagcount or ""
end

-- lua/me/statusline.lua [Help][+][RO]
M.filename = function()
    return "%f%( %h%w%m%r%)"
end

-- ● lua utf-8[unix]
M.fileinfo = function()
    local filetype = vim.bo.filetype
    local sep = filetype ~= "" and " " or ""
    local fileencoding = vim.bo.fileencoding
    local fileformat = vim.bo.fileformat
    local icon = state.lsp_attached and config.lsp_icon or ""

    return ("%s%s%s%s[%s]"):format(icon, filetype, sep, fileencoding, fileformat)
end

-- 23,3 (All)
M.ruler = function()
    return "%-6.(%l,%v%) (%P)"
end

local diag_cb = function(args)
    local buf = args.buf
    local count = vim.diagnostic.count(buf)

    if #count == 0 then
        state.diagcount[buf] = nil
        if vim.api.nvim_get_current_buf() == buf then
            vim.cmd.redrawstatus()
        end
    end

    local t = {}
    for _, v in ipairs(config.diagnostic) do
        local c = count[vim.diagnostic.severity[v.name]]
        if c and c > 0 then
            t[#t + 1] = ("%%#%s#%s%s%%*"):format(v.hl, v.sign, c)
        end
    end
    state.diagcount[buf] = #t > 0 and table.concat(t, " ")  or nil

    if vim.api.nvim_get_current_buf() == buf then
        vim.cmd.redrawstatus()
    end
end

local component = function(str)
    if str == "" then return "" end
    return (" %s "):format(str)
end

M.statusline = function()
    local comp = {
        M.filename(), M.gitinfo(), M.diagcount(),
        "%=",
        "%{v:lua.require'me.lsp.status'.get_progress()}",
        M.fileinfo(), M.ruler()
    }

    return table.concat(vim.tbl_map(function(v)
        return component(v)
    end, comp, ""))
end

M.setup = function()
    local augroup = vim.api.nvim_create_augroup("me.statusline", { clear = true })
    vim.api.nvim_create_autocmd("DiagnosticChanged", { group = augroup, callback = diag_cb })
    vim.api.nvim_create_autocmd({"LspAttach", "LspDetach"}, {
        group = augroup,
        callback = vim.schedule_wrap(function()
            state.lsp_attached = vim.tbl_count(vim.lsp.get_clients()) > 0
        end),
    })

    return "%{%v:lua.require'me.statusline'.statusline()%}"
end

M._debug = function()
    vim.print(state)
end

M._benchmark = function(func, n)
    n = n or 10000
    local tot_time = 0

    func = func or M.statusline

    for _ = 1, n do
        local start = vim.uv.hrtime()
        func()
        tot_time = tot_time + vim.uv.hrtime() - start
    end

    vim.print(("Total average time: %.3f ms"):format(tot_time / n / 1000000))
end

return M
