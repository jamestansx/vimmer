local M = {}
local H = {}

local lua_version = "5.1"
local tree = ("%s/site/pack/deps/luarocks"):format(vim.fn.stdpath("data"))
local default_opts = {
    "--tree", tree,
    "--lua-version",  lua_version,
    "--deps-mode", "one", "--deps-only",
}

M.setup = function()
    assert(vim.fn.executable("luarocks") == 1)

    local path = ("%s/share/lua/%s"):format(tree, lua_version)
    local cpath = ("%s/lib/lua/%s"):format(tree, lua_version)

    package.path = H.export(package.path, path, { "?.lua", "?/init.lua" })
    package.cpath = H.export(package.cpath, cpath, { "?.so" })
end

M.build = function(name, path)
    H.notify(("%s: Installing dependencies"):format(name))

    local rockspec = vim.fs.find(function(name, _)
        return name:match(".*%-1.rockspec$")
    end, { path = path, type = "file", limit = 1 })[1]

    if rockspec == nil then
        H.error(("%s: Could not find rockspec!"):format(name))
    end

    local obj = vim.system(H.cmd("build", rockspec)):wait()
    if obj.code ~= 0 then
        H.notify(("%s: Error installing dependencies"):format(name), "ERROR")
    else
        H.notify(("%s: Installed dependencies"):format(name))
    end
end

--- Wrapper for MiniDeps.add that injects `luarocks build` to hooks
M.add = function(spec, opts)
    vim.validate("spec", spec, "table")

    local hooks = spec["hooks"]
    local post_install = hooks and hooks["post_install"]
    local post_chekcout = hooks and hooks["post_chekcout"]

    spec = vim.tbl_deep_extend("force", spec, {
        hooks = {
            post_install = H.inject(M.build, post_install),
            post_chekcout = H.inject(M.build, post_chekcout),
        },
    })

    MiniDeps.add(spec, opts)
end

H.notify = function(msg, lvl)
    vim.notify(("(Luarocks) %s"):format(msg), vim.log.levels[lvl or "INFO"])
    vim.cmd.redraw()
end

H.error = function(msg) error(("(Luarocks) %s"):format(msg), 0) end

H.export = function(dest, source, wildcards)
    local pp = vim.split(dest, ";", { plain = true, trimempty = true })
    local it = vim.iter(wildcards)

    it:map(function(v) return ("%s/%s"):format(source, v) end)
    it:filter(function(v) return not vim.tbl_contains(pp, v) end)

    return table.concat(vim.iter({ pp, it:totable() }):flatten(math.huge):totable(), ";")
end

H.cmd = function(action, ...)
    return vim.iter({ "luarocks", action, default_opts, ... }):flatten(math.huge):totable()
end

H.inject = function(action, fn)
    return function(args)
        action(args.name, args.path)
        if type(fn) == "function" then
            fn(args)
        end
    end
end

return M
