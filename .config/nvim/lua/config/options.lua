-- options.lua: Neovim basic settings

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
vim.o.background = "dark"  -- Disable OSC 11 background detection
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"
-- SSH接続時はOSC52、ローカルGUIではシステムクリップボード(xclip/wl-clipboard)
if os.getenv("SSH_CONNECTION") then
    vim.g.clipboard = "osc52"
end
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
