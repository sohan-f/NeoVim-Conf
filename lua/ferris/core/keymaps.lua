-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local api = vim.api

-- Basic
map("i", "jj", "<Esc>", { desc = "Escape insert" })

map("n", "<leader>q", "<cmd>q!<CR>", { silent = true, desc = "Quit force" })
map("n", "<leader>w", vim.cmd.write, { desc = "Save file" })

map("n", "<leader>so", vim.cmd.source, { desc = "Source file" })

-- Wrap toggle
map("n", "<leader>uw", function()
    local wrap = not vim.wo.wrap
    vim.wo.wrap = wrap
    vim.wo.linebreak = wrap
    vim.wo.breakindent = wrap
end, { desc = "Toggle wrap" })

-- Visual
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })
map("x", "p", [["_dP]], { silent = true })

-- Search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

map("n", "<leader>S",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Rename word under cursor" }
)

-- Diagnostics / LSP
map("n", "<leader>dg", vim.diagnostic.open_float, { desc = "Line diagnostics" })

map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled)
end, { desc = "Toggle inlay hints" })

-- Terminal Runner
local terminals = {}

local function focus_buf(buf)
    for _, win in ipairs(api.nvim_list_wins()) do
        if api.nvim_win_get_buf(win) == buf then
            api.nvim_set_current_win(win)
            return true
        end
    end
end

local function run(cmd, key)
    if terminals[key] and api.nvim_buf_is_valid(terminals[key]) then
        if not focus_buf(terminals[key]) then
            vim.cmd("sb " .. terminals[key])
        end
    else
        if cmd and cmd ~= "" then
            vim.cmd("terminal " .. cmd)
        else
            vim.cmd("terminal")
        end
        terminals[key] = api.nvim_get_current_buf()
    end
    vim.cmd.startinsert()
end

local function input_run(prompt, base, key, default)
    vim.ui.input({ prompt = prompt, default = default or "" }, function(args)
        if not args then
            return
        end
        local full = base .. (args ~= "" and (" " .. args) or "")
        run(full, key)
    end)
end

map("n", "<leader>tb", function()
    run("", "interactive")
end, { desc = "Interactive terminal" })

map("n", "<leader>tr", function()
    run("cargo run", "cargo_run")
end, { desc = "Cargo run" })

map("n", "<leader>cb", function()
    run("cargo build", "cargo_build")
end, { desc = "Cargo build" })

map("n", "<leader>ct", function()
    input_run(
        "Cargo test args: ",
        "RUSTFLAGS='-A warnings' cargo test",
        "cargo_test",
        "-- --exact --nocapture --quiet"
    )
end, { desc = "Cargo test" })

map("n", "<leader>ma", function()
    input_run("Make args: ", "make", "make")
end, { desc = "Make" })

map("n", "<leader>mi", function()
    run("intercept-build make -j2", "intercept")
end, { desc = "Intercept build" })

map("n", "<leader>mp", function()
    run("npm start", "npm_start")
end, { desc = "NPM start" })

-- Clipboard Toggle
map("n", "<leader>tc", function()
    local cb = vim.opt.clipboard:get()
    local has = vim.tbl_contains(cb, "unnamedplus")

    if has then
        vim.opt.clipboard:remove("unnamedplus")
    else
        vim.opt.clipboard:append("unnamedplus")
    end

    vim.notify("Clipboard " .. (has and "OFF" or "ON"))
end, { desc = "Toggle clipboard" })

-- Terminal Escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Command-line Wildmenu Navigation
for k, v in pairs({
    ["<Up>"]    = 'wildmenumode() ? "\\<Left>"  : "\\<Up>"',
    ["<Down>"]  = 'wildmenumode() ? "\\<Right>" : "\\<Down>"',
    ["<Left>"]  = 'wildmenumode() ? "\\<Up>"    : "\\<Left>"',
    ["<Right>"] = 'wildmenumode() ? "\\<Down>"  : "\\<Right>"',
}) do
    map("c", k, v, { expr = true })
end


-- ================== SELF UPDATE ==================

vim.api.nvim_create_user_command("FerrisUpdate", function(opts)
    local config_dir = vim.fn.stdpath("config")

    if vim.fn.isdirectory(config_dir .. "/.git") == 0 then
        return vim.notify("Ferris: config is not a git repository", vim.log.levels.ERROR)
    end

    local function git(cmd)
        local cwd = vim.fn.getcwd()
        vim.fn.chdir(config_dir)
        local out = vim.fn.system(cmd)
        local err = vim.v.shell_error
        vim.fn.chdir(cwd)
        return out, err
    end

    --  FETCH ONLY (no working tree touch)
    if opts.args == "fetch" then
        vim.notify("Ferris: fetching updates…")
        local out, err = git({ "git", "fetch", "--quiet" })
        if err ~= 0 then
            return vim.notify("Ferris: fetch failed\n" .. out, vim.log.levels.ERROR)
        end
        return vim.notify("Ferris: fetch complete")
    end

    --  STATUS (ahead / behind / dirty)
    if opts.args == "status" then
        local out = vim.fn.system({
            "git",
            "-C",
            config_dir,
            "status",
            "--short",
            "--branch",
        })
        return vim.notify("Ferris status:\n" .. out)
    end

    --  LOG (recent commits)
    if opts.args == "log" then
        local out = vim.fn.system({
            "git",
            "-C",
            config_dir,
            "log",
            "--oneline",
            "--decorate",
            "-5",
        })
        return vim.notify("Ferris log:\n" .. out)
    end

    --  DEFAULT: SAFE UPDATE
    vim.notify("Ferris: updating configuration…")

    local out, err = git({ "git", "pull", "--ff-only" })
    if err ~= 0 then
        return vim.notify("Ferris: update failed\n" .. out, vim.log.levels.ERROR)
    end

    --  HOT-RELOAD SUPPORT
    pcall(function()
        dofile(config_dir .. "/init.lua")
    end)

    vim.notify("Ferris: update complete · config reloaded")
end, {
    nargs = "?",
    complete = function()
        return { "fetch", "status", "log" }
    end,
})
