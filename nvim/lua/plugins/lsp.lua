return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "github/copilot.vim",
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "rust_analyzer", "pylsp", "pyright" },
                auto_install = true,
                automatic_enable = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("lua_ls", {
                capabilities = { capabilities },
            })
            vim.lsp.config("ts_ls", {
                capabilities = { capabilities },
            })
            vim.lsp.config("tailwindcss", {
                capabilities = { capabilities },
            })
            vim.lsp.config("pylsp", {
                capabilities = { capabilities },
            })
            vim.lsp.config("pyright", {
                capabilities = { capabilities },
            })
            vim.lsp.config("clangd", {
                capabilities = { capabilities },
            })
        end,
    },
}
