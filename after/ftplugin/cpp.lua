local u = require("ferris.utils")

u.map("n", "<leader>mi", function()
	u.run("intercept-build make -j2", "intercept")
end, vim.tbl_extend("force", u.buf, { desc = "Intercept build" }))

u.map("n", "<leader>ma", function()
	u.input_run("Make args: ", "make", "make")
end, vim.tbl_extend("force", u.buf, { desc = "Make" }))
