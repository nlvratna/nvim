require("leela.core.options")
require("leela.core.keymaps")

vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help" },
	callback = function()
		vim.keymap.set("n", "<Esc>", ":q<CR>", { buffer = true, silent = true })
	end,
})

