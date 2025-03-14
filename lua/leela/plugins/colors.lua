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
			})

			-- Telescope highlights for Rose Pine main variant
			-- local colors = require("rose-pine.palette")

			-- vim.cmd("highlight! link TelescopeBorder FloatBorder")
			-- vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.base, fg = colors.text })
			-- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = colors.base, fg = colors.rose })
			-- vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.text })
			-- vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = colors.surface, fg = colors.rose })
			-- vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = colors.surface, fg = colors.text })
			-- vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = colors.surface, fg = colors.overlay })
			-- vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.overlay, fg = colors.text, bold = true })
			-- vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.rose, bold = true })
			-- vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = colors.base, fg = colors.text })
			-- vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = colors.base, fg = colors.overlay })
			-- vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = colors.rose, fg = colors.base })
			--
			--
			vim.cmd("colorscheme rose-pine")
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
