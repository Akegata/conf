-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.api.nvim_set_keymap("n", "<C-p>", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-o>", ":Neotree focus<CR>", { noremap = true, silent = true })

-- Move left with Ctrl+hjkl
vim.api.nvim_set_keymap('n', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true, silent = true })
