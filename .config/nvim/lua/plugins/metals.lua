-- metals.lua: Scala Metals LSP configuration using nvim-metals

return {
    "scalameta/nvim-metals",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
        local metals_config = require("metals").bare_config()

        -- Capabilities for completion
        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Metals settings
        metals_config.settings = {
            javaHome = "/usr/lib/jvm/java-17-openjdk-amd64",
            serverVersion = "1.6.4",  -- Use stable version
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            showInferredType = true,
            superMethodLensesEnabled = true,
            enableSemanticHighlighting = true,
        }

        -- Status handler for LSP progress
        metals_config.init_options = {
            statusBarProvider = "on",
        }

        metals_config.on_attach = function(client, bufnr)
            -- LSP keymaps (same as lsp.lua)
            local keymap = vim.keymap.set
            local opts = { buffer = bufnr }

            keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
            keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
            keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
            keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
            keymap("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
            keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
            keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
            keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
            keymap("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
            keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
            keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
            keymap("n", "<leader>fm", function()
                vim.lsp.buf.format({ async = true })
            end, vim.tbl_extend("force", opts, { desc = "Format" }))

            -- Metals-specific keymaps
            keymap("n", "<leader>ws", function()
                require("metals").hover_worksheet()
            end, vim.tbl_extend("force", opts, { desc = "Metals worksheet hover" }))

            keymap("n", "<leader>mc", function()
                require("metals").commands()
            end, vim.tbl_extend("force", opts, { desc = "Metals commands" }))

            keymap("n", "<leader>mi", function()
                require("metals").organize_imports()
            end, vim.tbl_extend("force", opts, { desc = "Metals organize imports" }))
        end

        return metals_config
    end,
    config = function(self, metals_config)
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end,
}
