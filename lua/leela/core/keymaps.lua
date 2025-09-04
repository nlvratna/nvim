-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "-", vim.cmd.Ex, opts)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- yank into  system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', opts)

vim.keymap.set("n", "<C-c>", "<cmd> w <CR>", opts)

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
-- mostly for go
vim.keymap.set("v", "<leader>g", "$%", opts)

-- delete single character without copying into register
-- vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Buffers
vim.keymap.set("n", "<leader>d", ":bdelete!<CR>", opts) -- close buffer

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ float = true, count = 1 })
end, opts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ float = true, count = -1 })
end, opts)

vim.keymap.set(
	"n",
	"<leader>v",
	vim.diagnostic.open_float,
	{ desc = "Open floating diagnostic message", silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>t", function()
	vim.diagnostic.setqflist({ open = false })
end, opts)

vim.keymap.set(
	"n",
	"[q",
	"<Cmd>try | cnext | catch | cfirst | catch | endtry<CR>",
	{ desc = "go to next in quickfix list", silent = true }
)
vim.keymap.set("n", "]q", "<Cmd>try | cprevious | catch | clast | catch | endtry<CR>", opts)
