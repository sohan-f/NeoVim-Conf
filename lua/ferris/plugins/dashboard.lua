return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",

	opts = function()
		local logo = [[
                 Æ ÆÆÆÆÆÆÆÆÆÆÆ Æ                
              Æ ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ Æ             
Æ ÆÆÆ       ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ       ÆÆÆ Æ
ÆÆÆÆÆÆ     ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ   ÆÆÆÆÆÆÆ
ÆÆÆÆÆÆÆ ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ ÆÆÆÆÆÆÆ
ÆÆÆÆÆÆÆ ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ ÆÆÆÆÆÆÆ
 ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ  ÆÆÆÆÆ  ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ
     ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ  ÆÆÆÆÆ  ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ    
    ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ   
     ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ   
      ÆÆÆÆÆÆ  ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ  ÆÆÆÆÆ     
        ÆÆÆÆÆ                        ÆÆÆÆÆ      
         ÆÆÆ                          ÆÆÆ       
]]

		local function button(key, label, action, icon)
			return {
				key = key,
				desc = " " .. label .. string.rep(" ", 30), -- adjust 6 to taste
				action = action,
				icon = icon .. " ",
			}
		end

		local function footer()
			local stats = require("lazy").stats()
			local ms = math.floor(stats.startuptime * 100) / 100

			return {
				"",
				("  %d/%d plugins loaded"):format(stats.loaded, stats.count),
				("󰅐  Startup: %.2f ms"):format(ms),
				"",
			}
		end

		return {
			theme = "doom",
			hide = { statusline = false },

			config = {
				header = vim.split("\n" .. logo .. "\n", "\n"),
				vertical_center = true,
				center = {
					button("f", "Find File", "Telescope find_files", ""),
					button("r", "Recent Files", "Telescope oldfiles", ""),
					button("n", "New File", "ene | startinsert", ""),
					button("c", "Config", function()
						require("telescope.builtin").find_files({
							cwd = vim.fn.stdpath("config"),
							hidden = true,
						})
					end, ""),
					button("l", "Lazy", "Lazy", "󰒲"),
					button("q", "Quit", "qa", ""),
				},

				footer = footer(),
			},
		}
	end,
}
