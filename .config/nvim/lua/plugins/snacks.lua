-- snacks.lua: Quality-of-life plugins collection

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            bufdelete = { enabled = true },
            dashboard = { enabled = true },
            dim = { enabled = true },
            gitbrowse = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            rename = { enabled = true },
            scope = { enabled = true },
            scratch = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            terminal = { enabled = true },
            toggle = { enabled = true },
            words = { enabled = true },
            zen = { enabled = true },
        },
        keys = {
            -- Buffer delete
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
            { "<leader>x", function() Snacks.bufdelete() end, desc = "Close buffer" },

            -- Git
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser (GitHub)" },

            -- Scratch
            { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
            { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },

            -- Notifier
            { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
            { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

            -- Terminal
            { "<leader>t", function() Snacks.terminal() end, desc = "Toggle terminal" },

            -- Words (LSP references)
            { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next LSP reference", mode = { "n", "t" } },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev LSP reference", mode = { "n", "t" } },

            -- Zen
            { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
            { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom (maximize window)" },

            -- Dim
            { "<leader>D", function() Snacks.dim() end, desc = "Toggle dim" },
        },
    },
}
