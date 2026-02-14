-- lsp.lua: Language Server Protocol configuration

return {
    -- Mason for LSP server management
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        lazy = false,
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "ts_ls",
                "clangd",
                "gopls",
            },
            automatic_installation = true,
        },
    },

    -- LSP Configuration (using new vim.lsp.config API)
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            -- LSP capabilities (for completion)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- LSP keymaps
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
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
                    keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { buffer = ev.buf, desc = "Previous diagnostic" })
                    keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { buffer = ev.buf, desc = "Next diagnostic" })
                    keymap("n", "<leader>fm", function()
                        vim.lsp.buf.format({ async = true })
                    end, { buffer = ev.buf, desc = "Format" })
                end,
            })

            -- Configure LSP servers using vim.lsp.config (Neovim 0.11+ API)
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            vim.lsp.config("pyright", {
                capabilities = capabilities,
            })

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        check = { command = "clippy" },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
            })

            vim.lsp.config("clangd", {
                capabilities = capabilities,
            })

            vim.lsp.config("gopls", {
                capabilities = capabilities,
                settings = {
                    gopls = {
                        semanticTokens = true,
                    },
                },
            })

            -- Enable LSP servers
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")
            vim.lsp.enable("rust_analyzer")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("clangd")
            vim.lsp.enable("gopls")
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
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
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
