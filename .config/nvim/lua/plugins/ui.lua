-- ui.lua: UI plugins (statusline, winbar, etc.)

return {
    -- Winbar with breadcrumb navigation
    {
        "Bekaboo/dropbar.nvim",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        opts = {
            bar = {
                -- Show for all normal file buffers (including those without treesitter/LSP)
                enable = function(buf, win, _)
                    if
                        not vim.api.nvim_buf_is_valid(buf)
                        or not vim.api.nvim_win_is_valid(win)
                        or vim.fn.win_gettype(win) ~= ""
                        or vim.wo[win].winbar ~= ""
                        or vim.bo[buf].ft == "help"
                    then
                        return false
                    end
                    return vim.bo[buf].bt == ""
                end,
            },
        },
        config = function(_, opts)
            require("dropbar").setup(opts)
            local dropbar_api = require("dropbar.api")
            vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
            vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
            vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "tokyonight",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
            scope = {
                enabled = true,
            },
        },
    },

    -- Improved UI for messages, cmdline, and hover
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = { enabled = true },
                signature = { enabled = true },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
    },

    -- Which-key (shows keybindings)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps",
            },
        },
    },
}
