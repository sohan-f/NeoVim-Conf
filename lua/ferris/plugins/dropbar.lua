return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy", -- Load when needed, not at startup
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	keys = {
		{
			"<leader>dp",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick dropbar component",
		},
	},
	opts = function()
		local sources = require("dropbar.sources")
		return {
			bar = {
				exclude_logics = {
					function(buf, _)
						return vim.bo[buf].filetype == "terminal"
							or vim.bo[buf].buftype == "terminal"
							or vim.bo[buf].filetype == "toggleterm"
					end,
				},
			},
		}
	end,
}
