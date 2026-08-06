-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.shellcmdflag = "-ic"

-- Root = cwd, so terminals and lazygit follow the project picked with the
-- projects picker instead of the current buffer's old root.
vim.g.root_spec = { "cwd" }
