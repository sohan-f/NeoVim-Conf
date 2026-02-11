return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		indent = {
			char = "│", -- The vertical line character
			tab_char = "│",
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = false,
			injected_languages = false,
			highlight = { "Function", "Label" }, -- Colors the scope line based on your theme
		},
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
		},
	},
}
