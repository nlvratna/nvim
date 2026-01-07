---@param server string
function StartLsp(server)
  vim.lsp.enable(server)
end

--https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/
-- local function setup_lsp()
--   local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
--   local lsp_servers = {}
--
--   if vim.fn.isdirectory(lsp_dir) == 1 then
--     for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
--       if file:match("%.lua$") and file ~= "init.lua" then
--         local server_name = file:gsub("%.lua$", "")
--         table.insert(lsp_servers, server_name)
--       end
--     end
--   end
--
--   vim.lsp.enable(lsp_servers)
-- end
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

    local lsp_attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
    local lsp_detach_group = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_attach_group,
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
      end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = lsp_detach_group,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })

    -- setup_lsp()
  end,
  -- require("mason-lspconfig").setup()
}
