--src: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
local root_markers1 = {
  ".emmyrc.json",
  ".luarc.json",
  ".luarc.jsonc",
}
local root_markers2 = {
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
}

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
      completion = {
        callSnippet = "Disable",
      },
    },

    runtime = { version = "LuaJIT" },
    workspace = {
      checkThirdParty = true,
      library = {
        -- "${3rd}/love2d/library",
        "${3rd}/luv/library",
        unpack(vim.api.nvim_get_runtime_file("", true)),
      },
    },
    diagnostics = { disable = { "missing-fields" } },
    format = {
      enable = false,
    },
  },
}
