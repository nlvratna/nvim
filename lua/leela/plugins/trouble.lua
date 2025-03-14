return {

	"folke/trouble.nvim",
	opts = {
		defaults = {
			keys = {
				["["] = "next",
				["]"] = "prev",
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>t",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{

			"<leader>q",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
