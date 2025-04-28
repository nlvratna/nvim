-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
		command = "Git",
	},

	-- {
	-- 	"norcalli/nvim-colorizer.lua",
	-- 	config = function()
	-- 		require("colorizer").setup()
	-- 	end,
	-- },

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup() --has to be loaded before everything
		end,
	},
}
