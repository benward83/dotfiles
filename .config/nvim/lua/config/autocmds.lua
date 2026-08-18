-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ElixirLS compiles in the background; if git rewrites the tree mid-compile,
-- Mix "resets" the mtime of files it saw change with File.touch!, which
-- recreates files git just deleted as empty phantoms. Pause the LSP while the
-- floating lazygit is open and bring it back when it closes.
local elixir_lsp = vim.api.nvim_create_augroup("ben_elixir_lsp_lazygit", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = elixir_lsp,
  pattern = "term://*lazygit*",
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients({ name = "elixirls" })) do
      client:stop()
    end
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  group = elixir_lsp,
  pattern = "term://*lazygit*",
  callback = function()
    vim.defer_fn(function()
      pcall(vim.cmd, "LspStart elixirls")
    end, 500)
  end,
})
