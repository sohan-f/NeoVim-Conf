return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "*",
	event = "InsertEnter",

	opts = {
		keymap = { preset = "enter" },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		completion = {
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_in_snippet = false,
				show_on_backspace = false,
				show_on_insert_on_trigger_character = false,
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 3000,
				window = { border = "rounded" },
			},

			menu = {
				border = "rounded",
				draw = {
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
				},
			},

			accept = { auto_brackets = { enabled = true } },
		},

		signature = {
			enabled = true,
			window = { border = "rounded" },
			trigger = { show_on_insert_on_trigger_character = false },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			min_keyword_length = 3,
			providers = {
				lsp = {
					min_keyword_length = 3,
					score_offset = 10,
				},
				path = {
					min_keyword_length = 3,
				},
				snippets = {
					min_keyword_length = 3,
					max_items = 6,
				},
				buffer = {
					max_items = 4,
					min_keyword_length = 4,
					score_offset = -5,
				},
			},
		},
	},
}
