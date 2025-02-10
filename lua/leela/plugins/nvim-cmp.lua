-- return { -- Autocompletion
-- 	"hrsh7th/nvim-cmp",
-- 	"saghen/blink.cmp",
-- 	dependencies = {
-- 		{
-- 			"L3MON4D3/LuaSnip",
-- 			build = (function()
-- 				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
-- 					return
-- 				end
-- 				return "make install_jsregexp"
-- 			end)(),
-- 			dependencies = {
-- 				{
-- 					"rafamadriz/friendly-snippets",
-- 					config = function()
-- 						require("luasnip.loaders.from_vscode").lazy_load()
-- 					end,
-- 				},
-- 			},
-- 		},
-- 		"saadparwaiz1/cmp_luasnip",
-- 		"hrsh7th/cmp-nvim-lsp",
-- 		"hrsh7th/cmp-buffer",
-- 		"hrsh7th/cmp-path",
-- 	},
-- 	config = function()
-- 		-- See `:help cmp`
-- 		local cmp = require("cmp")
-- 		local luasnip = require("luasnip")
-- 		luasnip.config.setup({})
--
-- 		local kind_icons = {
-- 			text = "󰉿",
-- 			method = "m",
-- 			function = "󰊕",
-- 			constructor = "",
-- 			field = "",
-- 			variable = "󰆧",
-- 			class = "󰌗",
-- 			interface = "",
-- 			module = "",
-- 			property = "",
-- 			unit = "",
-- 			value = "󰎠",
-- 			enum = "",
-- 			keyword = "󰌋",
-- 			snippet = "",
-- 			color = "󰏘",
-- 			file = "󰈙",
-- 			reference = "",
-- 			folder = "󰉋",
-- 			enummember = "",
-- 			constant = "󰇽",
-- 			struct = "",
-- 			event = "",
-- 			operator = "󰆕",
-- 			typeparameter = "󰊄",
-- 		}
-- 		cmp.setup({
-- 			snippet = {
-- 				expand = function(args)
-- 					luasnip.lsp_expand(args.body)
-- 				end,
-- 			},
-- 			completion = { completeopt = "menu,menuone,noinsert" },
-- 			mapping = cmp.mapping.preset.insert({
-- 				["<c-n>"] = cmp.mapping.select_next_item(),
-- 				["<c-p>"] = cmp.mapping.select_prev_item(),
-- 				["<c-b>"] = cmp.mapping.scroll_docs(-4),
-- 				["<c-f>"] = cmp.mapping.scroll_docs(4),
-- 				["<c-y>"] = cmp.mapping.confirm({ select = true }),
-- 				["<c-space>"] = cmp.mapping.complete({}),
--
-- 				["<c-l>"] = cmp.mapping(function()
-- 					if luasnip.expand_or_locally_jumpable() then
-- 						luasnip.expand_or_jump()
-- 					end
-- 				end, { "i", "s" }),
-- 				["<c-h>"] = cmp.mapping(function()
-- 					if luasnip.locally_jumpable(-1) then
-- 						luasnip.jump(-1)
-- 					end
-- 				end, { "i", "s" }),
-- 			}),
-- 			sources = {
-- 				{
-- 					name = "lazydev",
-- 					-- set group index to 0 to skip loading luals completions as lazydev recommends it
-- 					group_index = 0,
-- 				},
-- 				{ name = "nvim_lsp" },
-- 				{ name = "luasnip" },
-- 				{ name = "buffer" },
-- 				{ name = "path" },
-- 			},
-- 			formatting = {
-- 				fields = { "kind", "abbr", "menu" },
-- 				format = function(entry, vim_item)
-- 					vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
-- 					vim_item.menu = ({
-- 						nvim_lsp = "[lsp]",
-- 						luasnip = "[snippet]",
-- 						buffer = "[buffer]",
-- 						path = "[path]",
-- 					})[entry.source.name]
-- 					return vim_item
-- 				end,
-- 			},
-- 		})
-- 	end,
-- }
return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		opts = {
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {},
			-- default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
}
