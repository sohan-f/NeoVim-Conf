return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = { "BufAdd", "BufReadPre" },

	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				mode = "buffers",
				style_preset = bufferline.style_preset.minimal,
				numbers = "none",
				close_command = "bdelete %d",
				right_mouse_command = "bdelete %d",
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
				always_show_bufferline = false, -- Hides bufferline if only 1 buffer
				offsets = {
					{ filetype = "NvimTree", text = "EXPLORER", text_align = "left", separator = true },
				},
			},
			highlights = {
				buffer_selected = {
					italic = false, -- active buffer name in italics
				},
				diagnostic_selected = {
					italic = false,
				},
			},
		})
	end,
}
