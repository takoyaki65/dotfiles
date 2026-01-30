-- treesitter.lua: Syntax highlighting and code parsing

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false, -- This plugin does NOT support lazy-loading
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            -- Install parsers (runs async, won't block startup)
            require("nvim-treesitter").install({
                "bash",
                "c",
                "cpp",
                "css",
                "dockerfile",
                "go",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "rust",
                "scala",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            })
        end,
    },
}
