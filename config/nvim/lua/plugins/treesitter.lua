-- treesitter.lua: Syntax highlighting and code parsing

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            require("nvim-treesitter").setup({
                -- Grammars are provided by Nix (TREESITTER_GRAMMARS)
                auto_install = false,
            })

            -- Enable treesitter highlighting for all filetypes
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
