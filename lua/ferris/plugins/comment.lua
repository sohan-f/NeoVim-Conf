return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	opts = function()
		local ok, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
		return {
			pre_hook = ok and ts_comment.create_pre_hook() or nil,
		}
	end,
	keys = {
		-- <Leader>/ toggle current line (supports count)
		{
			"<Leader>/",
			function()
				return require("Comment.api").call(
					"toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"),
					"g@$"
				)()
			end,
			mode = "n",
			expr = true,
			silent = true,
			desc = "Toggle comment line",
		},

		-- visual mode toggle
		{
			"<Leader>/",
			"<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>",
			mode = "x",
			desc = "Toggle comment",
		},
	},
}
