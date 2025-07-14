return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		-- "hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local original_capabilities = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

		local servers = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				-- gofumpt = true,
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
}
