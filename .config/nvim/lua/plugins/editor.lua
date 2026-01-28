-- editor.lua: Editor enhancement plugins

return {
    -- File explorer (buffer-style)
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
            { "<leader>e", "<cmd>Oil --float<cr>", desc = "Open file explorer (float)" },
        },
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            view_options = {
                show_hidden = true,
            },
            win_options = {
                winbar = "%!v:lua.require('oil').get_current_dir()",
            },
            float = {
                padding = 2,
                max_width = 100,
                max_height = 30,
            },
            keymaps = {
                ["q"] = "actions.close",
                ["<Esc>"] = "actions.close",
            },
        },
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
        },
    },

    -- Commenting
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },

    -- Surround text objects
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
                map("n", "[h", gs.prev_hunk, { desc = "Previous hunk" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
            end,
        },
    },

    -- Better escape
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        opts = {
            timeout = 200,
        },
    },

    -- Seamless navigation between tmux panes and vim splits
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
        },
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
            { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
            { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
            { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
        },
    },
}
