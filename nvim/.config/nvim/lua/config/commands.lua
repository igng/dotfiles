vim.api.nvim_create_user_command("FormatToggle", function()
	local buf = vim.api.nvim_get_current_buf()

	vim.b[buf].disable_autoformat = not vim.b[buf].disable_autoformat

	if vim.b[buf].disable_autoformat then
		vim.notify("Autoformat disabled for this buffer")
	else
		vim.notify("Autoformat enabled for this buffer")
	end
end, {})
