-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
local function vmap(keys, fn, desc)
  vim.keymap.set("v", keys, fn, { desc = desc, noremap = true })
end

vmap("<LeftRelease>", '"*ygv', "yank on mouse selection")
