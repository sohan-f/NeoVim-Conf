local opt = vim.opt
local api = vim.api
vim.opt.laststatus = 3
-- ================== NUMBERS ==================

opt.rnu = true

api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
	callback = function(ev)
		opt.rnu = ev.event == "InsertLeave"
	end,
})

-- ================== UI ==================

opt.cmdheight = 0
opt.showcmd = false
opt.showmode = false
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.fillchars = { eob = " " }
opt.mousefocus = false
opt.lazyredraw = true

-- dynamic scrolloff (20% of screen)
api.nvim_create_autocmd("VimResized", {
	callback = function()
		opt.scrolloff = math.floor(vim.o.lines * 0.2)
	end,
})

-- ================== INDENT ==================

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.cindent = false
opt.smartindent = false

-- ================== SEARCH ==================

opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "nosplit"
opt.ignorecase = true
opt.smartcase = true

-- ================== FILE ==================

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.updatetime = 80
opt.backspace = { "start", "eol", "indent" }

-- ================== WRAP ==================

opt.wrap = false
opt.linebreak = false

-- ================== SHELL / CMD ==================

opt.shell = "zsh"
opt.wildmenu = true
opt.wildmode = "full"

---@diagnostic disable-next-line: undefined-field
opt.clipboard:append("unnamedplus")

vim.loader.enable()

-- ================== HIGHLIGHT ==================

local function set_hl()
	api.nvim_set_hl(0, "LineNr", { fg = "#ff9e64" })
end

set_hl()
api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

-- ================== DIAGNOSTICS ==================

vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = true,

	float = {
		border = "rounded",
		source = "always",
		focusable = true, -- required for scrolling
	},
})

-- Diagnostic signs (unchanged logic, clearer structure)
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌵 ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Hover diagnostics on CursorHold (only when relevant)
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		-- Do nothing if there are no diagnostics under cursor
		if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })) then
			return
		end

		vim.diagnostic.open_float(nil, {
			scope = "cursor", -- hover behavior
			focus = true, -- allows scrolling
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
