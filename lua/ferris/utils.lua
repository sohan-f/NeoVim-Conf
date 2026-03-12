local M = {}

M.map = vim.keymap.set
M.api = vim.api
M.buf = { buffer = true, silent = true }
M.terminals = {}

M.focus_buf = function(bufnr)
	for _, win in ipairs(M.api.nvim_list_wins()) do
		if M.api.nvim_win_get_buf(win) == bufnr then
			M.api.nvim_set_current_win(win)
			return true
		end
	end
end

M.run = function(cmd, key)
	if M.terminals[key] and M.api.nvim_buf_is_valid(M.terminals[key]) then
		if not M.focus_buf(M.terminals[key]) then
			vim.cmd("sb " .. M.terminals[key])
		end
	else
		vim.cmd(cmd ~= "" and ("terminal " .. cmd) or "terminal")
		M.terminals[key] = M.api.nvim_get_current_buf()
	end
	vim.cmd.startinsert()
end

M.input_run = function(prompt, base, key, default)
	vim.ui.input({ prompt = prompt, default = default or "" }, function(args)
		if not args then
			return
		end
		M.run(base .. (args ~= "" and (" " .. args) or ""), key)
	end)
end

return M
