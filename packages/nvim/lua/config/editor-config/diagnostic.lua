-- configuring diagnostic stuff --
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization --

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- enable diagnostic hover window --
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
--
