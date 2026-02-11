return {
	"j-hui/fidget.nvim",
	config = function()
		local comment_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
		local title_fg = vim.api.nvim_get_hl(0, { name = "Title" }).fg

		vim.api.nvim_set_hl(0, "FidgetClean", { fg = comment_fg, italic = false, standout = false, underline = false })
		vim.api.nvim_set_hl(0, "FidgetTitleClean", { fg = title_fg, bold = true, italic = false })

		require("fidget").setup({
			progress = {
				display = {
					done_icon = " ",
					progress_icon = {
						pattern = {
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
							" ",
						},
						period = 1.15,
					},
					group_style = "FidgetTitleClean",
					done_style = "FidgetClean",
					progress_style = "FidgetClean",
				},
			},
			notification = {
				window = {
					winblend = 0,
					normal_hl = "FidgetClean",
				},
				view = {
					group_separator_hl = "FidgetClean",
				},
			},
		})
	end,
}
