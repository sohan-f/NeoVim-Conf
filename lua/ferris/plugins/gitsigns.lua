return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			signs = {
				add = { text = "+", show_count = false },
				change = { text = "▎", show_count = false },
				delete = { text = "▁", show_count = false },
				topdelete = { text = "▔", show_count = false },
				changedelete = { text = "▋", show_count = false },
				untracked = { text = "┆", show_count = false },
			},

			preview_config = {
				style = "minimal",
				relative = "cursor",
			},

			current_line_blame = true,

			on_attach = function(bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "gs", gitsigns.toggle_signs, "Toggle git signs")
				map("n", "gp", gitsigns.preview_hunk, "Preview hunk")
				map("n", "]h", gitsigns.next_hunk, "Next hunk")
				map("n", "[h", gitsigns.prev_hunk, "Prev hunk")
			end,
		})
	end,
}
