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

        vim.api.nvim_buf_create_user_command(0, "Run", function()
            local file = vim.fn.expand("%:p")

            local manifest = vim.fs.find("Cargo.toml", {
                path = vim.fs.dirname(file),
                upward = true,
            })[1]

            if not manifest then
                vim.notify("Cargo.toml not found", vim.log.levels.ERROR)
                return
            end

            local output = vim.fn.system({
                "cargo", "metadata",
                "--no-deps",
                "--format-version", "1",
                "--manifest-path", manifest,
            })

            if vim.v.shell_error ~= 0 then
                vim.notify(output, vim.log.levels.ERROR)
                return
            end

            local metadata = vim.json.decode(output)
            local package

            for _, pkg in ipairs(metadata.packages) do
                local pkg_manifest = vim.fs.normalize(pkg.manifest_path)

                if vim.startswith(file, vim.fs.dirname(pkg_manifest) .. "/") then
                    package = pkg.name
                    break
                end
            end

            if not package then
                vim.notify("Could not determine Cargo package for current file", vim.log.levels.ERROR)
                return
            end

            local makeprg = vim.opt_local.makeprg:get()

            vim.opt_local.makeprg = "cargo run --package " .. vim.fn.shellescape(package)
            vim.cmd("make!")

            vim.opt_local.makeprg = makeprg
        end, {})
    end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = "make",
    command = "cwindow",
})
