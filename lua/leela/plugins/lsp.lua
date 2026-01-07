return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    -- "mason-org/mason.nvim",
    -- "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- require("mason").setup()

    -- diagnostic config
    vim.diagnostic.config({
      severity_sort = true,
      jump = { float = true },
      float = { border = "rounded", source = "if_many" },
      -- float = false,
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = false,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local builtin = require("telescope.builtin")
        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gr", vim.lsp.buf.references, "Show References")
        map("sd", vim.lsp.buf.document_symbol, "")
        map("<leader>l", builtin.lsp_workspace_symbols, "")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>o", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<C-l>", vim.lsp.buf.signature_help, "show help", "i")

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "lsp-detach", buffer = event2.buf })
          end,
        })
      end,
    })

    -- require("mason-lspconfig").setup()
  end,
}
