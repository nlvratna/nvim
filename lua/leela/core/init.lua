require("leela.core.options")
require("leela.core.keymaps")

vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- vim.diagnostic.config({
-- 	virtual_text = {
-- 		prefix = "●",
-- 		format = function(diagnostic)
-- 			local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
-- 			return string.format("%s %s", code, diagnostic.message)
-- 		end,
-- 	},
-- 	underline = false,
-- 	update_in_insert = true,
-- 	float = {
-- 		source = "if_many", -- Or "if_many"
-- 	},
-- 	on_ready = function()
-- 		vim.cmd("highlight DiagnosticVirtualText guibg=NONE")
-- 	end,
-- })

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
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
