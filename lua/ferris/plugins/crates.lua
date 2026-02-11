return {
	"Saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("crates").setup({
			lsp = {
				enabled = true,
				on_attach = function(bufnr) end,
				actions = true,
				completion = true,
				hover = true,
			},
		})
	end,
}
