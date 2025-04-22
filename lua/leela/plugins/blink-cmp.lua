return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				documentation = {
					auto_show = true,
					treesitter_highlighting = true,
				},

				menu = {
					-- border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						treesitter = { "lsp" },
					},
				},
			},

			cmdline = {
				enabled = true,
				-- keymap = {
				-- 	["<Tab>"] = { "show", "accept" },
				-- },
				completion = {
					menu = {
						auto_show = true,
					},
				},
			},

			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						opts = {
							search_paths = { vim.fn.stdpath("config") .. "/lua/leela/core/snippets" },
						},
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
