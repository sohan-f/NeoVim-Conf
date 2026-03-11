return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
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
