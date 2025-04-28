local M = {}
local diagnostics_shown = false

local getDiagnostics = function(opts)
	opts = opts or {}
	local diagnostics = vim.diagnostic.get(opts.bufnr)
	local qfixlist = {}

	if #diagnostics == 0 then
		vim.notify("No diagnostics to show", vim.log.levels.WARN)
		return
	end
	-- Loop through the diagnostics and construct the quickfix list
	for _, diag in ipairs(diagnostics) do
		local diag_message = diag.message
		local severity_icon = ""

		-- Check if the diagnostic has user_data (indicating it's from LSP)
		if diag.user_data and diag.user_data.lsp then
			-- LSP specific handling
			local lsp_diag = diag.user_data.lsp
			severity_icon = ({
				[1] = "󰅚 ", -- ERROR
				[2] = "󰀪 ", -- WARNING
				[3] = "󰋽 ", -- INFO
				[4] = "󰌶 ", -- HINT
			})[lsp_diag.severity] or ""
			diag_message = lsp_diag.message
		else
			-- Non-LSP diagnostics
			severity_icon = ({
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			})[diag.severity] or ""
		end

		-- Add the diagnostic to the quickfix list
		table.insert(qfixlist, {
			bufnr = diag.bufnr,
			lnum = diag.lnum + 1, -- Quickfix is 1-indexed
			col = diag.col + 1, -- Quickfix is 1-indexed
			text = diag_message,
			type = severity_icon,
		})
	end

	-- Set the quickfix list with the new diagnostics
	if diagnostics_shown then
		vim.cmd("cclose")
	else
		vim.fn.setqflist(qfixlist, "r")
		if opts.open_qf ~= false then
			vim.cmd("copen")
		end
	end
	diagnostics_shown = not diagnostics_shown
end

-- Function to go to next quickfix item and show diagnostic float, with wraparound
local cnext_with_float = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()

	-- if diagnostics == nil then
	-- 	print("no diagnostics to go to")
	-- 	return
	-- end

	for _, diag in ipairs(diagnostics) do
		if current_buf ~= diag.bufnr then
			vim.api.nvim_set_current_buf(diag.bufnr)
			vim.diagnostic.jump({ count = 1, float = true })
		end
	end
end

-- Function to go to previous quickfix item and show diagnostic float, with wraparound
local cprev_with_float = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()

	-- if diagnostics == nil then
	-- 	print("no diagnostics to go to")
	-- 	return
	-- end

	for _, diag in ipairs(diagnostics) do
		if current_buf ~= diag.bufnr then
			vim.api.nvim_set_current_buf(diag.bufnr)
			vim.diagnostic.jump({ count = 1, float = true })
		end
	end
end

M.getDiagnostics = getDiagnostics
M.cnext_with_float = cnext_with_float
M.cprev_with_float = cprev_with_float
M.setup = function()
	-- Set up keymap for quickfix diagnostics
	vim.keymap.set("n", "<leader>t", function()
		M.getDiagnostics()
	end)
	vim.keymap.set("n", "[d", function()
		M.cnext_with_float()
	end)
	vim.keymap.set("n", "]d", function()
		M.cprev_with_float()
	end)

	-- Set up autocommand to refresh diagnostics on DiagnosticChanged
	-- vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	-- 	callback = function()
	-- 		M.getDiagnostics({ open_qf = false })
	-- 	end,
	-- })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			vim.keymap.set("n", "q", ":cclose<CR>", { buffer = true })
		end,
	})
end

return M
