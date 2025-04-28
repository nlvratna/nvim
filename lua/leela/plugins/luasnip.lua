return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- or latest
	event = "InsertEnter",
	build = "make install_jsregexp", -- needed for some snippet types
	dependencies = { "rafamadriz/friendly-snippets", event = "InsertEnter" },

	config = function()
		require("luasnip").setup({
			enable_autosnippets = true,
			history = true,
		})
		-- require("luasnip.loaders.from_lua").lazy_load({
		-- 	paths = { vim.fn.stdpath("config") .. "/lua/leela/core/snippets" },
		-- })
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/lua/leela/core/snippets/vscode" },
		})
	end,
}
