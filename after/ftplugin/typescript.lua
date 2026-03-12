local u = require("ferris.utils")

u.map("n", "<leader>mp", function()
	u.run("npm start", "npm_start")
end, vim.tbl_extend("force", u.buf, { desc = "NPM start" }))
