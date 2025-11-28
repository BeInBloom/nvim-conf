local map = vim.keymap.set

map("n", "H", "<cmd>bprevious<cr>", { silent = true, desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })
