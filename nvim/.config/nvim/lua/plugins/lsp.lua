return {
	{
		"mason-org/mason.nvim",
		opts = {
			signature = {
				enabled = true,
			},
		},
	},

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			"mason-org/mason.nvim",
			"saghen/blink.cmp",
		},

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("clangd", {
				capabilities = capabilities,

				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})

			vim.lsp.enable({
				"clangd",
				"pyright",
				"lua_ls",
			})
		end,
	},
}
