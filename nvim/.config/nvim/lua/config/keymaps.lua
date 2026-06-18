-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- greatest remap ever
vim.keymap.set("n", "x", [["_x]])
vim.keymap.set({ "n", "v" }, "d", [["_d]])
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- navigation
vim.keymap.set("n", "<Up>", "<C-u>")
vim.keymap.set("n", "<Down>", "<C-d>")
