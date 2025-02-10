return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon").setup()
		vim.keymap.set("n", "<C-w>", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<leader>f", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<leader>d", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<leader>n", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():select(4)
		end)
	end,
}
