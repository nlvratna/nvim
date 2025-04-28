return {
	{
		"rose-pine/neovim",
		priority = 1000,
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "main", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				styles = {
					italic = false,
				},
				palette = {
					main = {
						base = "#000000",
					},
				},
				highlight_groups = {
					TelescopeNormal = { bg = "base" },
					TelescopeResultsNormal = { bg = "base" },
					TelescopePromptsNormal = { bg = "base" },
					TelescopeBorder = { bg = "base" },
					-- BlinkCmpDoc = { bg = "highlight_low" },
				},
			})

			vim.cmd("colorscheme rose-pine")
			-- vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#191724" }) future reference
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- use the night style
				style = "night",
				-- disable italic for functions
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					functions = { italic = false },
					variables = { italic = false },
				},
				-- Change the "hint" color to the "orange" color, and make the "error" color bright red
				on_colors = function(colors)
					colors.hint = colors.orange
					-- colors.error = "#ff0000"
					colors.green = "#9ccfd8"
					colors.bg = "#000000"
					-- colors.bg_dark = "#1f1d2e"
				end,
			})
			-- vim.cmd("colorscheme tokyonight-night")
		end,
	},
}
