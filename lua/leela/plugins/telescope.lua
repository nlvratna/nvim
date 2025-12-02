return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				preview = false,
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					no_ignore = true,
				},
				lsp_references = {
					initial_mode = "normal",
				},
				lsp_document_symbols = {
					preview = true,
				},
				diagnostics = {
					initial_mode = "normal",
				},
				grep_string = {
					initial_mode = "normal",
				},
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
			},
			extensions = {
				fzf = {},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>g", function()
			builtin.grep_string({
				search = vim.fn.input({ prompt = "grep > " }),
			})
			vim.keymap.set("n", "<leader>gg", builtin.grep_string)
		end, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>k", builtin.current_buffer_fuzzy_find)
		vim.keymap.set("n", "<leader>j", builtin.lsp_document_symbols, { desc = "Search for symbols in the document" })

		-- vim.keymap.set("n", "<leader>j", function()
		-- 	builtin.live_grep({
		-- 		grep_open_files = true,
		-- 		prompt_title = "Live Grep in Open Files",
		-- 	})
		-- end, { desc = "Grep in Open files" })
	end,
}
