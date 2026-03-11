local api = vim.api

api.nvim_create_autocmd("TextYankPost", {
	group = api.nvim_create_augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
