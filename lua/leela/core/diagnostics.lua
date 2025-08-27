local diag_next = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local current_row, current_col = current_pos[1] - 1, current_pos[2]

	local all_diags = vim.diagnostic.get()
	if #all_diags == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	-- Sort diagnostics by buffer, then line, then column
	table.sort(all_diags, function(a, b)
		if a.bufnr ~= b.bufnr then
			return a.bufnr < b.bufnr
		elseif a.lnum ~= b.lnum then
			return a.lnum < b.lnum
		else
			return a.col < b.col
		end
	end)

	local found_diag = nil
	for _, diag in ipairs(all_diags) do
		if diag.bufnr == current_buf then
			if diag.lnum > current_row or (diag.lnum == current_row and diag.col > current_col) then
				found_diag = diag
				break
			end
		elseif diag.bufnr > current_buf then
			-- Found next buffer with diagnostic
			found_diag = diag
			break
		end
	end

	-- If nothing found, wrap around to first diagnostic
	if not found_diag then
		found_diag = all_diags[1]
	end

	vim.api.nvim_set_current_buf(found_diag.bufnr)
	vim.api.nvim_win_set_cursor(0, { found_diag.lnum + 1, found_diag.col })
	vim.diagnostic.open_float(nil, { scope = "line" })
end

local diag_prev = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local current_row, current_col = current_pos[1] - 1, current_pos[2]

	local all_diags = vim.diagnostic.get()
	if #all_diags == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	-- Sort diagnostics by buffer, line, column in reverse order
	table.sort(all_diags, function(a, b)
		if a.bufnr ~= b.bufnr then
			return a.bufnr > b.bufnr
		elseif a.lnum ~= b.lnum then
			return a.lnum > b.lnum
		else
			return a.col > b.col
		end
	end)

	local found_diag = nil
	for _, diag in ipairs(all_diags) do
		if diag.bufnr == current_buf then
			if diag.lnum < current_row or (diag.lnum == current_row and diag.col < current_col) then
				found_diag = diag
				break
			end
		elseif diag.bufnr < current_buf then
			-- Found earlier buffer with diagnostic
			found_diag = diag
			break
		end
	end

	-- If nothing found, wrap around to last diagnostic
	if not found_diag then
		found_diag = all_diags[1]
	end

	vim.api.nvim_set_current_buf(found_diag.bufnr)
	vim.api.nvim_win_set_cursor(0, { found_diag.lnum + 1, found_diag.col })
	-- vim.diagnostic.open_float(nil, { scope = "line" })
end

vim.diagnostic.config({
	severity_sort = true,
	jump = { float = true },
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})
vim.keymap.set("n", "[d", function()
	diag_next()
end, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "]d", function()
	diag_prev()
end, { desc = "Go to previous diagnostic" })
