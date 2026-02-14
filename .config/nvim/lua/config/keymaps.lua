-- keymaps.lua: Key mappings
-- Note: Window/pane navigation is handled by vim-tmux-navigator

local keymap = vim.keymap.set

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- Clear search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Keep cursor centered when searching
keymap("n", "n", "nzzzv", { desc = "Next search result centered" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Jump past next closing delimiter in insert mode
keymap("i", "<C-l>", function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local after = line:sub(col + 1)
    local pos = after:find("[%)%]}>\"']")
    if pos then
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col + pos })
    end
end, { desc = "Jump past closing delimiter" })

-- Save file
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

