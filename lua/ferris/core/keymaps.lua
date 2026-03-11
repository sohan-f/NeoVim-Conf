vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local api = vim.api

-- Basic
map("i", "jj", "<Esc>", { desc = "Escape insert" })
map("n", "<leader>q", "<cmd>q!<CR>", { silent = true, desc = "Quit force" })
map("n", "<leader>w", "<cmd>w<CR>", { silent = true, desc = "Save file" })

-- Clipboard
local clipboard_enabled = true
vim.opt.clipboard = "unnamedplus"
map("n", "<leader>ce", function()
	clipboard_enabled = not clipboard_enabled
	if clipboard_enabled then
		vim.opt.clipboard = "unnamedplus"
		vim.notify("Clipboard: system (+)")
	else
		vim.opt.clipboard = ""
		vim.notify("Clipboard: Neovim default")
	end
end, { desc = "Toggle system clipboard" })

-- Visual
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
map("v", "<", "<gv", { silent = true, desc = "Indent left" })
map("v", ">", ">gv", { silent = true, desc = "Indent right" })
map("x", "p", [["_dP]], { silent = true, desc = "Paste without yanking" })

-- Search

map("n", "n", "nzzzv", { desc = "Next result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev result (centered)" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word under cursor" })

-- Standard buffer switching
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })

-- Diagnostics

map("n", "<leader>dg", vim.diagnostic.open_float, { desc = "Line diagnostics" })

--Terminal runner

local terminals = {}

local function focus_buf(buf)
	for _, win in ipairs(api.nvim_list_wins()) do
		if api.nvim_win_get_buf(win) == buf then
			api.nvim_set_current_win(win)
			return true
		end
	end
end

local function run(cmd, key)
	if terminals[key] and api.nvim_buf_is_valid(terminals[key]) then
		if not focus_buf(terminals[key]) then
			vim.cmd("sb " .. terminals[key])
		end
	else
		vim.cmd(cmd ~= "" and ("terminal " .. cmd) or "terminal")
		terminals[key] = api.nvim_get_current_buf()
	end
	vim.cmd.startinsert()
end

local function input_run(prompt, base, key, default)
	vim.ui.input({ prompt = prompt, default = default or "" }, function(args)
		if not args then
			return
		end
		run(base .. (args ~= "" and (" " .. args) or ""), key)
	end)
end

map("n", "<leader>tb", function()
	run("", "interactive")
end, { desc = "Interactive terminal" })
map("n", "<leader>tr", function()
	run("cargo run", "cargo_run")
end, { desc = "Cargo run" })
map("n", "<leader>cb", function()
	run("cargo build", "cargo_build")
end, { desc = "Cargo build" })
map("n", "<leader>mi", function()
	run("intercept-build make -j2", "intercept")
end, { desc = "Intercept build" })
map("n", "<leader>mp", function()
	run("npm start", "npm_start")
end, { desc = "NPM start" })

map("n", "<leader>ct", function()
	input_run("Cargo test args: ", "RUSTFLAGS='-A warnings' cargo test", "cargo_test", "-- --exact --nocapture --quiet")
end, { desc = "Cargo test" })

map("n", "<leader>ma", function()
	input_run("Make args: ", "make", "make")
end, { desc = "Make" })

-- cli nav

local wildmenu_keys = {
	["<Up>"] = 'wildmenumode() ? "\\<Left>"  : "\\<Up>"',
	["<Down>"] = 'wildmenumode() ? "\\<Right>" : "\\<Down>"',
	["<Left>"] = 'wildmenumode() ? "\\<Up>"    : "\\<Left>"',
	["<Right>"] = 'wildmenumode() ? "\\<Down>"  : "\\<Right>"',
}
for k, v in pairs(wildmenu_keys) do
	map("c", k, v, { expr = true })
end
