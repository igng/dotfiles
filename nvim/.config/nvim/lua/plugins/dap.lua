return {
	{
		"mfussenegger/nvim-dap",

		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Continue",
			},

			{
				"<F9>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle breakpoint",
			},

			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step over",
			},

			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step into",
			},

			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step out",
			},

			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Terminate",
			},
		},

		config = function()
			local dap = require("dap")

			dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DiagnosticWarn",
				linehl = "",
				numhl = "",
			})
		end,
	},
}
