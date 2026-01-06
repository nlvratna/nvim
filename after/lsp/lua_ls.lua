return {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      completion = {
        callSnippet = "Disable",
      },
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          "${3rd}/love2d/library",
          "${3rd}/luv/library",
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      diagnostics = { disable = { "missing-fields" } },
      format = {
        enable = false,
      },
    },
  },
  vim.lsp.enable("lua_ls"),
}
