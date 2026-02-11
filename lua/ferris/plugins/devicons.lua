return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = {
			override_by_extension = {
				["c"] = { color = "#6495ed", icon = "", name = "C" },
				["js"] = { color = "#f7df1e", icon = "", name = "Js" },
			},
			default = true,
		},
	},
	{
		"onsails/lspkind.nvim",
		opts = {
			mode = "symbol_text",
			preset = "codicons",
			symbol_map = {
				TypeParameter = "󰬛",
			},
		},
	},
}
