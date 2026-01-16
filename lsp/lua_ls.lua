return {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      completion = {
        callSnippet = "Disable",
      },
      runtime = { version = "LuaJIT" },
      diagnostics = { disable = { "missing-fields" } },
      format = {
        enable = false,
      },
    },
  },
}
