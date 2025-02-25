local M = {}

-- TODO: use ++all args to select all lsp clients (not only from the current buffer)
local get_clients_from_names = function(names)
    if #names == 0 then
        return vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    else
        return vim.iter(vim.lsp.get_clients()):filter(function(v)
            return vim.tbl_contains(names, v.name)
        end):totable()
    end
end

local stop_clients = function(cls, forced)
    local detached_cls = {}

    for i = 1, #cls do
        if vim.tbl_count(cls[i].attached_buffers) > 0 then
            detached_cls[i] = { cls[i], vim.lsp.get_buffers_by_client_id(cls[i].id) }
        end
        cls[i]:stop(forced)
    end

    return detached_cls
end

M.complete_client_names = function()
    return vim.iter(vim.lsp.get_clients()):map(function(v)
        return v.name
    end):totable()
end

M.restart = function(names, forced)
    names = names or {}
    forced = forced or false

    local cls = get_clients_from_names(names)
    local detached_cls = stop_clients(cls, forced)

    -- non-blocking lsp restart
    local timer = assert(vim.uv.new_timer())
    timer:start(500, 100, vim.schedule_wrap(function()
        for i = 1, #detached_cls do
            local cl, bufs = unpack(detached_cls[i])

            if cl.is_stopped() then
                for j = 1, #bufs do
                    vim.lsp.start(cl.config, { bufnr = bufs[j] })
                end
                detached_cls[i] = nil
            end
        end

        if next(detached_cls) == nil and not timer:is_closing() then
            timer:close()
        end
    end))
end

M.stop = function(names, forced)
    names = names or {}
    forced = forced or false

    local cls = get_clients_from_names(names)
    stop_clients(cls, forced)
end

M.log_open = function()
    vim.cmd(("tabnew %s"):format(vim.lsp.get_log_path()))
end

M.log_clear = function()
    vim.fs.rm(vim.lsp.get_log_path())
end

return M
