-- Core
vim.loader.enable()

local opt = vim.opt
local api = vim.api
local o = vim.o

o.laststatus = 3

-- Numbers
opt.number = true
opt.relativenumber = true

api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = api.nvim_create_augroup("DynamicRelativeNumber", { clear = true }),
    callback = function(ev)
        opt.relativenumber = (ev.event == "InsertLeave")
    end,
})

-- UI
opt.cmdheight = 0
opt.showcmd = false
opt.showmode = false
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.fillchars = { eob = " " }
opt.mousefocus = false
opt.lazyredraw = true

-- Dynamic scrolloff
local function update_scrolloff()
    opt.scrolloff = math.floor(vim.o.lines * 0.2)
end

api.nvim_create_autocmd({ "VimResized", "UIEnter" }, {
    group = api.nvim_create_augroup("DynamicScrolloff", { clear = true }),
    callback = update_scrolloff,
})

update_scrolloff()

-- Indent
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.cindent = false
opt.smartindent = false

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "nosplit"
opt.ignorecase = true
opt.smartcase = true

-- File
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.updatetime = 80
opt.backspace = { "start", "eol", "indent" }

-- Wrap
opt.wrap = false
opt.linebreak = false

-- Shell / Cmd
opt.shell = "zsh"
opt.wildmenu = true
opt.wildmode = "full"

opt.clipboard:append("unnamedplus")

-- Highlight
local function set_hl()
    api.nvim_set_hl(0, "LineNr", { fg = "#ff9e64" })
end

api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("CustomHighlights", { clear = true }),
    callback = set_hl,
})

set_hl()

-- Diagnostics
vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = true,
    float = {
        border = "rounded",
        source = "always",
        focusable = true,
    },
})

local signs = {
    Error = " ",
    Warn  = " ",
    Hint  = "󰌵 ",
    Info  = " ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = "",
    })
end

api.nvim_create_autocmd("CursorHold", {
    group = api.nvim_create_augroup("DiagnosticHover", { clear = true }),
    callback = function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
        if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
            return
        end

        vim.diagnostic.open_float(nil, {
            scope = "cursor",
            focus = true,
            border = "rounded",
            close_events = {
                "CursorMoved",
                "InsertEnter",
                "BufLeave",
                "FocusLost",
            },
        })
    end,
})
