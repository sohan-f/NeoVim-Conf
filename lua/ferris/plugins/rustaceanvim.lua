return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		ft = "rust",
		config = function()
			local termux_prefix = "/data/data/com.termux/files/usr/bin/"

			vim.g.rustaceanvim = {
				server = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								extraEnv = { CARGO_PROFILE_RUST_ANALYZER_INHERITS = "dev" },
								extraArgs = { "--profile", "rust-analyzer" },
							},
							check = {
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							files = {
								excludeDirs = { ".direnv", ".git", "target" },
							},
						},
					},
				},
				dap = {
					adapter = require("rustaceanvim.config").get_codelldb_adapter(
						termux_prefix .. "codelldb",
						"/data/data/com.termux/files/usr/lib/liblldb.so"
					),
				},
			}
		end,
	},
}
