return {
	{
		"stevearc/conform.nvim",
		enabled = true,
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			local conform = require("conform")

			-- shared groups
			local prettier_ft = {
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"html",
				"css",
			}

			local formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				rust = { "rustfmt" },
			}

			-- assign prettier to all its filetypes
			for _, ft in ipairs(prettier_ft) do
				formatters_by_ft[ft] = { "prettier" }
			end

			conform.setup({
				formatters_by_ft = formatters_by_ft,

				format_on_save = {
					timeout_ms = 5000,
					lsp_fallback = true,
				},

				formatters = {
					prettier = {
						prepend_args = {
							"--tab-width",
							"4",
							"--use-tabs",
							"false",
						},
					},

					clang_format = {
						prepend_args = { "--style=file" },
					},
				},
			})
		end,
	},
}
