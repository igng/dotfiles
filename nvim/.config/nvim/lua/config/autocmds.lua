local group = vim.api.nvim_create_augroup("MyConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "rust",
    callback = function()
        vim.opt_local.makeprg = "cargo check --message-format=short"

        vim.opt_local.errorformat = table.concat({
            "%f:%l:%c: %t%*[^:]: %m",
            "%f:%l: %t%*[^:]: %m",
            "%-G%.%#",
        }, ",")
    end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = "make",
    command = "cwindow",
})
