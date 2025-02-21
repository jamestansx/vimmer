vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

vim.o.confirm = true
vim.o.colorcolumn = "+1"
vim.o.exrc = true
vim.o.mouse = "a"
vim.o.mousemodel = "extend"
vim.o.selection = "old" -- don't select past line
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h,r/tmp"
vim.o.synmaxcol = 200
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.virtualedit = "block"
vim.opt.isfname:append("@-@")
-- set includeexpr=substitute(v:fname,'^[^\/]*/','','')

-- editing
vim.o.jumpoptions = "clean,stack,view"
vim.o.scrolloff = 5
vim.o.sidescroll = 3
vim.o.sidescrolloff = 3
vim.opt.matchpairs:append("<:>")
vim.opt.diffopt:append("algorithm:histogram,indent-heuristic")

-- completion
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.pumheight = 5
vim.o.wildcharm = (""):byte()
vim.o.wildmode = "longest:full,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.opt.wildignore:append("*/__pycache__/*,*/node_modules/*")

-- highlight 'number' column instead of indentation
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.numberwidth = 1
vim.o.number = true
vim.o.relativenumber = true

-- consistent window splitting
vim.o.splitbelow = true
vim.o.splitright = true

-- less noise
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.shortmess = "aoOstTAIcCF"
vim.o.showcmd = false
vim.o.signcolumn = "yes:1"

-- spaces between us
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.softtabstop = -1
vim.o.shiftround = true

-- improve search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"

-- wrap option
vim.o.wrap = false
vim.o.breakindent = true
vim.o.linebreak = true

vim.o.list = true
vim.o.listchars = table.concat({
    "extends:🠞",  -- U+1F81E
    "nbsp:⦸",     -- U+29B8
    "precedes:🠜", -- U+1F81C
    "tab:  »",    -- U+00BB
    "trail:·",    -- U+00B7
}, ",")

if vim.fn.executable("rg") == 1 then
    vim.o.grepprg = "rg --vimgrep --smart-case -uu"
    vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- ftplugin may include 'o' option
local augroup = vim.api.nvim_create_augroup("me.options", { clear = true })
vim.api.nvim_create_autocmd("FileType", { group = augroup, command = "setlocal fo-=o" })

vim.diagnostic.config({
    severity_sort = true,
    jump = { float = true },
    signs = { severity = { min = 'WARN', max = 'ERROR' } },
})
