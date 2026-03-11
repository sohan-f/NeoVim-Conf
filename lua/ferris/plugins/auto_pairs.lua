return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")

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
	end,
}
