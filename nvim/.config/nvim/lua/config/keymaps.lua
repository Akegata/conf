-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.api.nvim_set_keymap('n', '<C-o>', ':Neotree toggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':Neotree focus<CR>', { noremap = true, silent = true })
