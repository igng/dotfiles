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
    virtual_text = false,
    underline = true,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        wrap = true,
    },
})

-- Wait 500ms before triggering CursorHold
vim.opt.updatetime = 500

-- Automatically show diagnostics under the cursor
vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
            scope = "line",
        })
    end,
})
