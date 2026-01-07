return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        ST100 = false,
      },
      gofumpt = true,
    },
  },
  vim.lsp.enable("gopls"),
}
