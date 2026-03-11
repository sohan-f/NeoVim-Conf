return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",

	opts = function()
		local logo = {
			[[]],
			[[                                       ]],
			[[    ▄   ▄███▄   ████▄     ▄   ▄█ █▀▄▀█ ]],
			[[     █  █▀   ▀  █   █      █  ██ █ █ █ ]],
			[[ ██   █ ██▄▄    █   █ █     █ ██ █ ▄ █ ]],
			[[ █ █  █ █▄   ▄▀ ▀████  █    █ ▐█ █   █ ]],
			[[ █  █ █ ▀███▀           █  █   ▐    █  ]],
			[[ █   ██                  █▐        ▀   ]],
			[[                         ▐             ]],
			[[                                       ]],
			[[]],
			[[]],
		}
		local function button(key, label, action, icon)
			return {
				key = key,
				desc = " " .. label .. string.rep(" ", 14),
				action = action,
				icon = icon .. " ",
			}
		end

		local function footer()
			local ok, lazy = pcall(require, "lazy")
			if not ok then
				return {}
			end

			local stats = lazy.stats()

			local startuptime = stats.startuptime or 0

			local ms = math.floor(startuptime * 100) / 100

			return {
				"",
				("󰅐 Startup: %.2f ms (%d/%d plugins loaded)"):format(ms, stats.loaded, stats.count),
				"",
			}
		end

		return {
			theme = "doom",
			hide = { statusline = false },

			config = {
				header = logo,
				vertical_center = true,
				center = {
					button("f", "Find File", function()
						Snacks.picker.files()
					end, ""),
					button("r", "Recent Files", function()
						Snacks.picker.recent()
					end, ""),
					button("n", "New File", "ene | startinsert", ""),
					button("c", "Config", function()
						Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true })
					end, ""),
					button("l", "Lazy", "Lazy", "󰒲"),
					button("q", "Quit", "qa", ""),
				},

				footer = footer,
			},
		}
	end,
}
