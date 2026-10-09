return {
    {
        "saghen/blink.cmp",

        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = {
            keymap = {
                preset = "none",

                ["<Up>"] = {
                    "select_prev",
                    "fallback",
                },

                ["<Down>"] = {
                    "select_next",
                    "fallback",
                },

                ["<Tab>"] = {
                    "accept",
                    "fallback",
                },

                ["<C-space>"] = {
                    "show",
                },

                ["<C-e>"] = {
                    "hide",
                },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                menu = {
                    auto_show = true,
                },
                documentation = {
                    auto_show = true,
                },
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },

            signature = {
                enabled = true,
            },
        },
    },
}

