return {
	"folke/flash.nvim",
	event = "VeryLazy", -- CursorHold works, but VeryLazy is the standard for UI tools
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump({
					action = function(match, state)
						state:hide()
						match:jump()
						vim.cmd("normal! zz")
					end,
				})
			end,
			desc = "Flash Jump & Center",
		},
	},
}
