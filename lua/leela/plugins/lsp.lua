return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
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
						group = vim.api.nvim_create_augroup("ratna", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "ratna", buffer = event2.buf })
						end,
					})
				end,
			})

			vim.filetype.add({
				extension = {
					templ = "templ",
				},
			})
			local original_capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

			local servers = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
				html = { filetypes = { "templ", "html", "twig", "hbs" } },

				tailwindcss = {
					filetypes = {
						"templ",
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					init_options = {
						userLanguages = {
							templ = "html",
						},
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									-- for templ or other non-standard syntaxes
									{ "tw`([^`]*)", 1 },
									{ 'tw="([^"]*)', 1 },
									{ "tw\\(([^)]*)\\)", 1 },
									{ "class:([\\w-]+)", 1 },
									{ 'class\\s*=\\s*"([^"]*)', 1 },
								},
							},
						},
					},
				},

				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
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
				},
			}
			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls",
					"lua_ls",
				},
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup() --has to be loaded before everything
		end,
	},
}
