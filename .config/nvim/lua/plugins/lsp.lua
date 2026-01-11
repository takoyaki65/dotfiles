-- lsp.lua: Language Server Protocol configuration

return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            { "j-hui/fidget.nvim", opts = {} }, -- LSP progress indicator
        },
        config = function()
            -- Setup Mason first
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",        -- Lua
                    "pyright",       -- Python
                    "rust_analyzer", -- Rust
                    "ts_ls",         -- TypeScript/JavaScript
                    "clangd",        -- C/C++
                },
                automatic_installation = true,
            })

            -- LSP keymaps
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    local keymap = vim.keymap.set

                    keymap("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
                    keymap("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
                    keymap("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
                    keymap("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
                    keymap("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
                    keymap("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
                    keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
                    keymap("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
                    keymap("n", "<leader>e", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show diagnostics" })
                    keymap("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Previous diagnostic" })
                    keymap("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Next diagnostic" })
                    keymap("n", "<leader>fm", function()
                        vim.lsp.buf.format({ async = true })
                    end, { buffer = ev.buf, desc = "Format" })
                end,
            })

            -- LSP capabilities (for completion)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Setup language servers
            local lspconfig = require("lspconfig")

            -- Lua
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Python
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })

            -- Rust
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            })

            -- TypeScript/JavaScript
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            -- C/C++
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Load snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
}
