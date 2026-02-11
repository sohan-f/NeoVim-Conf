return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		require("nvim-tree").setup({
			sort_by = "case_sensitive",
			sync_root_with_cwd = true,
			respect_buf_cwd = true,

			view = {
				width = 26, -- Slightly narrower for mobile screens
				side = "left",
				preserve_window_proportions = true,
				number = false,
				relativenumber = false,
				signcolumn = "no", -- Saves 2 chars of width
			},

			renderer = {
				group_empty = true,
				highlight_git = true,
				highlight_opened_files = "all", -- Better visibility on small screens
				root_folder_label = ":~:s?$?/..?", -- Shortens long paths

				indent_markers = {
					enable = false, -- Disabling lines makes narrow views look less "busy"
				},

				icons = {
					padding = " ",
					symlink_arrow = " ➜ ",
					show = {
						file = true,
						folder = true,
						folder_arrow = true, -- Crucial for touch/mobile navigation
						git = true,
					},

					glyphs = {
						default = "󰈚",
						symlink = "",
						bookmark = "󰆤",
						folder = {
							arrow_closed = "",
							arrow_open = "",
							default = "󰉋",
							open = "󰝰",
							empty = "󰊕",
							empty_open = "󰷏",
							symlink = "󰉒",
						},
						git = {
							unstaged = "󱈸",
							staged = "󰄬",
							unmerged = "",
							renamed = "󰁕",
							untracked = "󰇘",
							deleted = "󰛉",
							ignored = "◌",
						},
					},
				},
			},

			diagnostics = {
				enable = true,
				show_on_dirs = true,
				icons = {
					hint = "󰌵",
					info = "󰋼",
					warning = "󱇎",
					error = "󰅙",
				},
			},

			filters = {
				dotfiles = false,
				custom = { "^.git$" },
			},

			actions = {
				open_file = {
					quit_on_open = true, -- Helpful on mobile to auto-close tree
					window_picker = { enable = false }, -- Picker is clunky on small screens
				},
			},
		})

		-- Keymaps (Optimized for mobile keyboards)
		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
		vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<CR>", opts)
	end,
}
