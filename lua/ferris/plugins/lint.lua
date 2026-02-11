return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		local eslint_ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
		lint.linters_by_ft = {}
		for _, ft in ipairs(eslint_ft) do
			lint.linters_by_ft[ft] = { "eslint_d" }
		end

		local eslint = lint.linters.eslint_d
		eslint.args = {
			"--no-warn-ignored",
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
