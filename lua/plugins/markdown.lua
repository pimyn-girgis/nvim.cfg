return {
    {    -- Markdown in browser
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    { -- Markdown in Terminal
        "MeanderingProgrammer/markdown.nvim",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
        ft = { "markdown" },
    }
}
