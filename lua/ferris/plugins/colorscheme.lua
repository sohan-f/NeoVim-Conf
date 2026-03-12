return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm", -- moon | storm | night | day
			transparent = false,
			terminal_colors = true,
		})

		vim.cmd.colorscheme("tokyonight")
	end,
}
