require("leela.core.options")
require("leela.core.keymaps")
require("leela.core.diagnostics")

vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local builtin = require("telescope.builtin")
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("gr", builtin.lsp_references, "Show References")
		map("sd", builtin.lsp_document_symbols, "")
		map("<leader>l", builtin.lsp_workspace_symbols, "")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>o", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		map("<C-l>", vim.lsp.buf.signature_help, "show help", "i")

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		--if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		--	local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
		--	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		--		buffer = event.buf,
		--		group = highlight_augroup,
		--		callback = vim.lsp.buf.document_highlight,
		--	})

		--	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		--		buffer = event.buf,
		--		group = highlight_augroup,
		--		callback = vim.lsp.buf.clear_references,
		--	})
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("ratna", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "ratna", buffer = event2.buf })
			end,
		})
	end,
})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
