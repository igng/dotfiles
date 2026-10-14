return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",

        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },

        keys = {
            {
                "<leader>ff",
                "<cmd>Telescope find_files<CR>",
                desc = "Find files",
            },
            {
                "<leader>fg",
                "<cmd>Telescope live_grep<CR>",
                desc = "Live grep",
            },
            {
                "<leader>fb",
                "<cmd>Telescope buffers<CR>",
                desc = "Buffers",
            },
            {
                "<leader>fh",
                "<cmd>Telescope help tags<CR>",
                desc = "Help tags",
            },
        },

        opts = {
            defaults = {
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",

                layout_config = {
                    prompt_position = "top",
                },

                mappings = {
                    i = {
                        ["<Esc>"] = function()
                            require("telescope.actions").close()
                        end,
                    },
                },
            },
        },
    },
}
