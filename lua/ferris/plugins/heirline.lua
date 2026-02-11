return {
	"rebelot/heirline.nvim",
	event = "UiEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lewis6991/gitsigns.nvim",
		{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils") -- <--- This is what was "nil"

		local MacroRecorder = {
			condition = function()
				return vim.fn.reg_recording() ~= ""
			end,
			provider = function()
				return " 󰑋  Recording @" .. vim.fn.reg_recording() .. " "
			end,
			hl = { fg = "orange", bold = true },
			utils.surround({ "", "" }, "bright_bg", {
				hl = { fg = "orange", bg = "bright_bg" },
			}),
			-- We need to force an update when recording starts/stops
			update = { "RecordingEnter", "RecordingLeave" },
		}

		-- bufferline
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffers",
				style_preset = bufferline.style_preset.minimal,
				theme = "tokyonight",
				numbers = "none",
				close_command = "bdelete! %d",
				right_mouse_command = "bdelete! %d",
				left_mouse_command = "buffer %d",
				indicator = { icon = "▎", style = "icon" },
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				separator_style = "thick",
				offsets = {
					{ filetype = "NvimTree", text = "EXPLORER", text_align = "left", separator = true },
				},
			},
		})

		vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
		vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
		vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close Buffer" })

		-- heirline
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		local function setup_colors()
			local get_hl = utils.get_highlight
			local function get_safe(group, prop, fallback)
				local hl = get_hl(group)
				if not hl or not hl[prop] then
					return fallback
				end
				return hl[prop]
			end

			return {
				bright_bg = get_safe("CursorLine", "bg", "#292e42"),
				bright_fg = get_safe("Normal", "fg", "#c0caf5"),
				normal_bg = get_safe("StatusLine", "bg", "#16161e"),
				normal_fg = get_safe("StatusLine", "fg", "#a9b1d6"),
				red = get_safe("DiagnosticError", "fg", "#f7768e"),
				green = get_safe("String", "fg", "#9ece6a"),
				blue = get_safe("Function", "fg", "#7aa2f7"),
				gray = get_safe("NonText", "fg", "#565f89"),
				orange = get_safe("Constant", "fg", "#ff9e64"),
				purple = get_safe("Statement", "fg", "#bb9af7"),
				cyan = get_safe("Special", "fg", "#7dcfff"),
				diag_warn = get_safe("DiagnosticWarn", "fg", "#e0af68"),
				diag_error = get_safe("DiagnosticError", "fg", "#db4b4b"),
				diag_hint = get_safe("DiagnosticHint", "fg", "#1abc9c"),
				diag_info = get_safe("DiagnosticInfo", "fg", "#0db9d7"),
				git_del = get_safe("GitSignsDelete", "fg", "#db4b4b"),
				git_add = get_safe("GitSignsAdd", "fg", "#41a6b5"),
				git_change = get_safe("GitSignsChange", "fg", "#e0af68"),
			}
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(setup_colors)
			end,
		})

		-- helpers
		local Spacer = { provider = " " }
		local Align = { provider = "%=" }
		local Divider = { provider = "│", hl = { fg = "gray" } }

		-- VI MODE
		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = "NOR",
					v = "VIS",
					V = "V-L",
					["\22"] = "V-B",
					s = "SEL",
					S = "S-L",
					i = "INS",
					R = "REP",
					c = "CMD",
					t = "TRM",
				},
				mode_colors = {
					n = "blue",
					i = "green",
					v = "purple",
					V = "purple",
					["\22"] = "purple",
					c = "orange",
					s = "purple",
					R = "red",
					r = "red",
					["!"] = "red",
					t = "red",
				},
			},
			{
				provider = "",
				hl = function(self)
					local mode_char = self.mode:sub(1, 1)
					return { fg = self.mode_colors[mode_char] or "purple", bg = "normal_bg" }
				end,
			},
			{
				provider = function(self)
					return " " .. (self.mode_names[self.mode] or self.mode)
				end,
				hl = function(self)
					local mode_char = self.mode:sub(1, 1)
					return { fg = "normal_bg", bg = self.mode_colors[mode_char] or "purple", bold = true }
				end,
			},
			{
				provider = "",
				hl = function(self)
					local mode_char = self.mode:sub(1, 1)
					return { fg = self.mode_colors[mode_char] or "purple", bg = "normal_bg" }
				end,
			},
		}

		-- GIT
		local Git = {
			condition = conditions.is_git_repo,

			init = function(self)
				self.status = vim.b.gitsigns_status_dict or {}
				self.added = self.status.added or 0
				self.removed = self.status.removed or 0
				self.changed = self.status.changed or 0
				self.head = self.status.head or ""
			end,

			-- DIFF COUNTER
			{
				{
					condition = function(self)
						return self.added > 0
					end,
					provider = function(self)
						return " " .. self.added .. " "
					end,
					hl = "GitSignsAdd",
				},
				{
					condition = function(self)
						return self.removed > 0
					end,
					provider = function(self)
						return " " .. self.removed .. " "
					end,
					hl = "GitSignsDelete",
				},
				{
					condition = function(self)
						return self.changed > 0
					end,
					provider = function(self)
						return " " .. self.changed .. " "
					end,
					hl = "GitSignsChange",
				},
			},
			--  BRANCH
			{
				flexible = 2,

				{
					provider = function(self)
						return self.head ~= "" and ("  " .. self.head .. " ") or ""
					end,
					hl = { fg = "purple", bold = true },
				},

				{
					provider = function(self)
						return self.head ~= "" and ("  " .. self.head:sub(1, 4) .. " ") or ""
					end,
					hl = { fg = "purple", bold = true },
				},

				{
					provider = "  ",
					hl = { fg = "purple" },
				},
			},
		}
		-- FILE: show icon + filetype/lang
		local FileBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
				self.ext = vim.fn.fnamemodify(self.filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(self.filename, self.ext, { default = true })
				-- prefer filetype for language name, fallback to extension
				self.lang = vim.bo.filetype or (self.ext ~= "" and self.ext) or ""
			end,
			flexible = 1,
			-- full: icon + language
			{
				provider = function(self)
					if self.filename == "" then
						return "[No Name]"
					end
					local name = self.lang ~= "" and self.lang or "[NoName]"
					if self.icon then
						return " " .. self.icon .. " " .. name .. " "
					end
					return " " .. name .. " "
				end,
				hl = function(self)
					return { fg = self.icon_color or "bright_fg", bold = true }
				end,
			},
			-- compact: icon only
			{
				provider = function(self)
					if self.filename == "" then
						return "[No Name]"
					end
					return self.icon and (" " .. self.icon .. " ") or ""
				end,
				hl = function(self)
					return { fg = self.icon_color or "bright_fg" }
				end,
			},
		}

		-- Diagnostics
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = { error_icon = " ", warn_icon = " ", info_icon = " ", hint_icon = " " },
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = "diag_error" },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = "diag_warn" },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = "diag_info" },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
				end,
				hl = { fg = "diag_hint" },
			},
		}

		-- LSP: flexible (full name / short / icon)
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			init = function(self)
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				self.client_name = (#clients > 0) and (clients[1].name or "") or ""
			end,
			flexible = 3,
			{
				provider = function(self)
					if self.client_name == "" then
						return ""
					end
					return "  " .. self.client_name .. " "
				end,
				hl = { fg = "green", bold = true },
			},
			{
				provider = "  ",
				hl = { fg = "green" },
			},
		}

		-- Ruler
		local Ruler = {
			{
				provider = "",
				hl = function()
					local mode_char = vim.fn.mode():sub(1, 1)
					local color = ViMode.static.mode_colors[mode_char] or "purple"
					return { fg = color, bg = "normal_bg" }
				end,
			},
			{
				hl = function()
					local mode_char = vim.fn.mode():sub(1, 1)
					local color = ViMode.static.mode_colors[mode_char] or "purple"
					return { fg = "normal_bg", bg = color }
				end,
				{
					provider = " ",
				},
				{
					provider = function()
						return string.format("%3d:%-2d", vim.fn.line("."), vim.fn.col("."))
					end,
				},
				{ provider = "│" },
				{
					provider = function()
						local current = vim.fn.line(".")
						local total = vim.fn.line("$")
						local percent = math.floor((current / total) * 100)
						return percent .. "%%"
					end,
				},
				{ provider = " " },
			},
			{
				provider = "",
				hl = function()
					local mode_char = vim.fn.mode():sub(1, 1)
					local color = ViMode.static.mode_colors[mode_char] or "purple"
					return { fg = color, bg = "normal_bg" }
				end,
			},
		}

		local FileAndLSP = {
			flexible = 3,

			-- FULL: file + full LSP
			{
				FileBlock,
				Spacer,
				LSPActive, -- full name
			},

			-- MEDIUM: file + LSP icon
			{
				FileBlock,
				Spacer,
				{
					condition = conditions.lsp_attached,
					provider = "  ",
					hl = { fg = "green" },
				},
			},

			-- SMALL: file icon + LSP icon
			{
				{
					flexible = 1,
					{
						FileBlock,
					},
					{
						provider = function(self)
							return self.icon and (" " .. self.icon .. " ") or ""
						end,
						hl = function(self)
							return { fg = self.icon_color or "bright_fg" }
						end,
					},
				},
				{
					condition = conditions.lsp_attached,
					provider = "  ",
					hl = { fg = "green" },
				},
			},
		}

		-- assemble statusline
		local StatusLine = {
			hl = { bg = "normal_bg" },

			ViMode,
			MacroRecorder,
			Spacer,
			Git,

			Align,

			FileAndLSP,

			Align,

			Diagnostics,
			Spacer,
			Ruler,
		}

		-- winbar
		-- local WinBar = {
		-- 	{
		-- 		provider = function()
		-- 			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		-- 			if filename == "" then
		-- 				return ""
		-- 			end
		-- 			local parts = vim.split(filename, "/")
		-- 			local res = "  "
		-- 			for i, part in ipairs(parts) do
		-- 				if i == #parts then
		-- 					res = res .. "%#NavicText#" .. part
		-- 				else
		-- 					res = res .. "%#NavicSeparator#" .. " " .. part .. " > "
		-- 				end
		-- 			end
		-- 			return res
		-- 		end,
		-- 		hl = { fg = "gray" },
		-- 	},
		-- }

		heirline.setup({
			statusline = StatusLine,
			opts = {
				colors = setup_colors,
				-- disable_winbar_cb = function(args)
				-- 	return conditions.buffer_matches({
				-- 		buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
				-- 		filetype = { "NvimTree", "neo-tree", "dashboard", "Outline", "aerial", "alpha" },
				-- 	}, args.buf)
				-- end,
			},
		})
	end,
}
