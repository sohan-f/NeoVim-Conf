return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 500,
		win = {
			border = "rounded",
			padding = { 1, 2 },
			title = true,
			title_pos = "center",
		},
		layout = {
			spacing = 3,
		},
		spec = {
			{ "<leader>b", group = "Buffer", icon = "󰓩 " },
			{ "<leader>g", group = "Git", icon = "󰊢 " },
			{ "<leader>l", group = "LSP", icon = "󰒋 " },
			{ "<leader>f", group = "Find", icon = "󰍉 " },
			{ "<leader>d", group = "Debug", icon = "󰃤 " },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps",
		},
	},
}
