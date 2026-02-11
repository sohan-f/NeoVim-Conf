return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		view = {
			wrap = true,
		},
	},
	keys = {
		-- Diagnostics
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project Diagnostics" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },

		-- LSP & Symbols
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.pos=right", desc = "LSP Definitions/Refs" },

		-- Lists
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
	},
}
