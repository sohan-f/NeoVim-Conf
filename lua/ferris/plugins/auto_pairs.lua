return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },

	config = function()
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cmp = require("cmp")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		autopairs.setup({
			check_ts = true,
		})

		-- Rust-specific rules
		autopairs.remove_rule("'")
		autopairs.add_rules({
			Rule("<", ">", "rust")
				:with_pair(function(opts)
					return opts.prev_char:match("[%w_]$")
				end)
				:with_move(function(opts)
					return opts.char == ">"
				end)
				:with_cr(function()
					return false
				end),
		})

		-- cmp integration
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
