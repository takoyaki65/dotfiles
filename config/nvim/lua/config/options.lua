-- options.lua: Neovim basic settings

-- Disable unused providers (was in the home-manager generated init.lua)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Add Nix-provided tree-sitter grammars to runtimepath
local treesitter_grammars = vim.env.TREESITTER_GRAMMARS
if treesitter_grammars then
    vim.opt.runtimepath:append(treesitter_grammars)
end

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
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
opt.autowriteall = true
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set compiler for filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.cmd("compiler cargo")
    end,
})
