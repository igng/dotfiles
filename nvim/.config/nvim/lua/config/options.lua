local opt = vim.opt

opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.mouse = "a"

opt.clipboard = "unnamedplus"

opt.smartcase = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"

opt.cursorline = true

opt.termguicolors = true

opt.updatetime = 250

vim.g.mapleader = ","

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	severity_sort = true,

	float = {
		border = "rounded",
	},
})
