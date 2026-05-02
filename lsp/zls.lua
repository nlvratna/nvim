---@brief
---src: https://github.com/neovim/nvim-lspconfig/lsp/zls.lua
--- https://github.com/zigtools/zls
---
--- Zig LSP implementation + Zig Language Server

---@type vim.lsp.Config
return {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git" },
  workspace_required = false,
  settings = {
    zls = {
      enable_argument_placeholders = false,
    },
  },
}
