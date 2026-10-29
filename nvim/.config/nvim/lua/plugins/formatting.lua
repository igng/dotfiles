local ok, formatting = pcall(require, "local.formatting")
local excluded = ok and formatting.excluded or {}

return {
    {
        "stevearc/conform.nvim",

        event = { "BufWritePre" },

        opts = {
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                python = { "ruff_format" },
                lua = { "stylua" },
            },

            format_on_save = function(bufnr)
                local filename = vim.api.nvim_buf_get_name(bufnr)

                if vim.tbl_contains(excluded, filename) then
                    return nil
                end

                if vim.b[bufnr].disable_autoformat then
                    return nil
                end

                return {
                    timeout_ms = 500,
                    lsp_fallback = true,
                }
            end,
        },

        config = function(_, opts)
            local conform = require("conform")

            conform.setup(opts)

            vim.api.nvim_create_user_command("FormatToggle", function()
                vim.b.disable_autoformat = not vim.b.disable_autoformat

                if vim.b.disable_autoformat then
                    vim.notify("Autoformat disabled for this buffer")
                else
                    vim.notify("Autoformat enabled for this buffer")
                end
            end, {})
        end,
    },
}
