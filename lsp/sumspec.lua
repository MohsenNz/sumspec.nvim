-- The SumSpec language server, `sumspec lsp`. Neovim 0.11 reads this file
-- as the default configuration of the "sumspec" server; enable it with
-- vim.lsp.enable("sumspec"), and change it with vim.lsp.config("sumspec", ...).
return {
  cmd = { "sumspec", "lsp" },
  filetypes = { "sumspec" },
  root_markers = { ".git" },
}
