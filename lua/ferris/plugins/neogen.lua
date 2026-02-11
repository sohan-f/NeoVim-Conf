return {
	"danymat/neogen",
	version = "*",
	keys = {
		{
			"<leader>df",
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Gen Func Doc",
		},
		{
			"<leader>dc",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Gen Class Doc",
		},
		{
			"<leader>dt",
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Gen Type Doc",
		},
	},
	opts = {
		enabled = true,
		languages = {
			javascript = { template = { annotation_convention = "jsdoc" } },
			typescript = { template = { annotation_convention = "tsdoc" } },
			c = { template = { annotation_convention = "doxygen" } },
			cpp = { template = { annotation_convention = "doxygen" } },
		},
	},
}
