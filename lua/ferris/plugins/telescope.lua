return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	-- Using 'keys' lets lazy.nvim load telescope only when these are pressed
	keys = {
		{ "<leader> ", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<C-g>", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "< NEOVIM CONFIG >",
					cwd = vim.fn.stdpath("config"),
					hidden = true,
				})
			end,
			desc = "Neovim Config",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						width = 0.9,
						height = 0.95,
						preview_height = 0.6,
						prompt_position = "top", -- "top" looks better with "ascending"
						mirror = true,
					},
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-u>"] = false, -- clear default scroll
						["<Esc>"] = actions.close,
					},
				},
				file_ignore_patterns = {
					"^.git/",
					"node_modules",
					"%.lock",
					"%.png",
					"%.jpg",
					"%.jpeg",
					"%.webp",
					"%.mp4",
					"%.mkv",
					"target/",
					"build/",
					"dist/",
					".cache/",
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim", -- Trim whitespace from results
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					-- fd is faster than find, and cleaner than `find_command`
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						"--hidden",
						"--exclude",
						".git",
					},
				},
				live_grep = {
					only_sort_text = true, -- Better performance
					disable_coordinates = true,
				},
				buffers = {
					ignore_current_buffer = true,
					sort_lastused = true,
					previewer = false, -- Buffers are usually text, preview might be overkill
					layout_config = { width = 0.7, height = 0.4 },
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
