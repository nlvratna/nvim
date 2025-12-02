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
	-- virtual_text = {
	-- 	prefix = "●",
	-- 	source = "if_many",
	-- 	spacing = 2,
	-- 	format = function(diagnostic)
	-- 		local diagnostic_message = {
	-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
	-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
	-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
	-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
	-- 		}
	-- 		return diagnostic_message[diagnostic.severity]
	-- 	end,
	-- },
})

--vim.api.nvim_create_autocmd("LspAttach", {
--	callback = function(event)
--		local map = function(keys, func, desc, mode)
--			mode = mode or "n"
--			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
--		end
--
--		local builtin = require("telescope.builtin")
--		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
--		map("gr", vim.lsp.buf.references, "Show References")
--		map("sd", vim.lsp.buf.document_symbol, "")
--		map("<leader>l", builtin.lsp_workspace_symbols, "")
--		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--		map("<leader>o", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
--		map("<C-l>", vim.lsp.buf.signature_help, "show help", "i")
--
--		vim.api.nvim_create_autocmd("LspDetach", {
--			group = vim.api.nvim_create_augroup("ratna", { clear = true }),
--			callback = function(event2)
--				vim.lsp.buf.clear_references()
--				vim.api.nvim_clear_autocmds({ group = "ratna", buffer = event2.buf })
--			end,
--		})
--	end,
--})
--
--vim.filetype.add({
--	extension = {
--		templ = "templ",
--	},
--})
--local original_capabilities = vim.lsp.protocol.make_client_capabilities()
--local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)
--
---- this works only with vim.lsp.config()
--vim.lsp.config("zls", { settings = { zls = { enable_argument_placeholders = false } } })
--local servers = {
--	-- zls = {
--	-- 	settings = {
--	-- 		zls = {
--	-- 			enable_argument_placeholders = false,
--	-- 		},
--	-- 	},
--	-- },
--	gopls = {
--		analyses = {
--			unusedparams = true,
--		},
--		staticcheck = true,
--		gofumpt = true,
--	},
--	html = { filetypes = { "templ", "html", "twig", "hbs" } },
--
--	tailwindcss = {
--		filetypes = {
--			"templ",
--			"html",
--			"css",
--			"scss",
--			"javascript",
--			"javascriptreact",
--			"typescript",
--			"typescriptreact",
--		},
--		init_options = {
--			userLanguages = {
--				templ = "html",
--			},
--		},
--		settings = {
--			tailwindCSS = {
--				experimental = {
--					classRegex = {
--						-- for templ or other non-standard syntaxes
--						{ "tw`([^`]*)", 1 },
--						{ 'tw="([^"]*)', 1 },
--						{ "tw\\(([^)]*)\\)", 1 },
--						{ "class:([\\w-]+)", 1 },
--						{ 'class\\s*=\\s*"([^"]*)', 1 },
--					},
--				},
--			},
--		},
--	},
--
--	lua_ls = {
--		settings = {
--			Lua = {
--				completion = {
--					callSnippet = "Replace",
--				},
--				runtime = { version = "LuaJIT" },
--				workspace = {
--					checkThirdParty = false,
--					library = {
--						"${3rd}/luv/library",
--						unpack(vim.api.nvim_get_runtime_file("", true)),
--					},
--				},
--				diagnostics = { disable = { "missing-fields" } },
--				format = {
--					enable = false,
--				},
--			},
--		},
--	},
--}
