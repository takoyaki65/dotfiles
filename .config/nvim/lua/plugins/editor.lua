-- editor.lua: Editor enhancement plugins

return {
    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
            { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
        },
        opts = {
            filesystem = {
                follow_current_file = { enabled = true },
                hijack_netrw_behavior = "open_default",
            },
            window = {
                width = 30,
                mappings = {
                    ["<space>"] = "none",
                },
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

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Horizontal terminal" },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical terminal" },
        },
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = {
                border = "curved",
            },
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
}
