return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		jump = {
			autojump = true,
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					on_jump = function()
						vim.cmd("normal! zz")
					end,
				})
			end,
			desc = "Flash Jump & Center",
		},
	},
}
