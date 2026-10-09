local map = vim.keymap.set

-- Global
map("t", "<Esc>", [[<C-\><C-n>]])
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
