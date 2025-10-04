-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Editor behavior
vim.opt.relativenumber = true
vim.opt.scrolloff = 10

-- Disable swap/backup files (rely on Git for version control)
-- This prevents "E325: ATTENTION" swap file warnings when opening files
vim.opt.swapfile = false -- No .swp files
vim.opt.backup = false -- No ~ backup files
vim.opt.writebackup = false -- No backup before overwriting file
