return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },

        opts = {
            ensure_installed = {
                "clangd",
                "lua-language-server",
            },
        },
    },
}
