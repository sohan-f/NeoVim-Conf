return {
	"nvim-treesitter/nvim-treesitter",
	commit = "42fc28ba918343ebfd5565147a42a26580579482",
	build = ":TSUpdate",
	event = { "BufEnter", "BufReadPre" },
	-- event = { "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	opts = {
		ensure_installed = {
			"bash",
			"diff",
			"html",
			"javascript",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"xml",
			"yaml",
		},
		highlight = { enable = true },
		indent = { enable = true },
		auto_install = false,
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
