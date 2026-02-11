# Ferris

A clean and efficient Neovim configuration managed with `lazy.nvim` tailored for coding productivity, and modern LSP features.

<p align="center">
  <img src="./images/screenshot.png" alt="Neovim Screenshot"/>
</p>

## Features

- **LSP Support** with `rustaceanvim` and `nvim-lspconfig`
- **Syntax Highlighting** via `nvim-treesitter`
- **Custom Dashboard** on startup
- **File Explorer** optimized with `nvim-tree`
- **Git Integration** through `gitsigns` and `lazygit`
- **Automatic Formatting & Linting**
- **UI Enhancements**: `heirline`, `fidget`, `dropbar`, `flash`
- **Utility Plugins**: `todo`, `text_objects`, `vim-hexokinase`, `crates`

## Installation
1. Install required packages:
```bash
apt update && yes | apt upgrade && apt update && yes | apt install build-essential zip termux-api gdu gdb gdbserver gh fd fzf neovim lua-language-server jq-lsp luarocks stylua ripgrep lazygit yarn python python-pip ccls clang zig rust-analyzer git ruby  && pip install neovim && npm install -g neovim && gem install neovim
```
2. Make backup of your current config:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```
3. Clone this repository:
```bash
git clone https://github.com/sohan-f/nvim-config.git ~/.config/nvim
```
4. Launch Neovim
```bash
nvim
```

## Done

---

> This setup is optimized for the Termux environment. Feel free to fork and customize!
