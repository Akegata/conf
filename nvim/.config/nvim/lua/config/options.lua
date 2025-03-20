-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
local function vmap(keys, fn, desc)
  vim.keymap.set("v", keys, fn, { desc = desc, noremap = true })
end

vmap("<LeftRelease>", '"*ygv', "yank on mouse selection")

local opt = vim.opt
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
