local diag_next = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))

	if #diagnostics == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	local found_next_diag = nil
	local first_diag_in_list = diagnostics[1] -- Keep track of the very first diagnostic for wraparound

	-- Try to find the next diagnostic *after* the current cursor position in the current buffer
	for _, diag in ipairs(diagnostics) do
		if diag.bufnr == current_buf then
			-- Compare line numbers first, then column numbers
			if diag.lnum > current_row or (diag.lnum == current_row and diag.col > current_col) then
				found_next_diag = diag
				break -- Found the next diagnostic in the current buffer
			end
		end
	end

	-- If no diagnostic found after current position in current buffer, find the first in *any* buffer after current
	if not found_next_diag then
		for _, diag in ipairs(diagnostics) do
			if diag.bufnr > current_buf then -- prioritize different buffers with higher bufnr
				found_next_diag = diag
				break
			elseif diag.bufnr == current_buf and diag.lnum >= current_row then -- current buffer again but after current line
				found_next_diag = diag
				break
			end
		end
	end

	if not found_next_diag then
		found_next_diag = first_diag_in_list
	end

	vim.api.nvim_set_current_buf(found_next_diag.bufnr)
	-- Diagnostics are 0-indexed for lnum and col, so add 1 for nvim_win_set_cursor
	vim.api.nvim_win_set_cursor(0, { found_next_diag.lnum + 1, found_next_diag.col })
	-- vim.diagnostic.open_float({
	-- 	scope = "line",
	-- })
end

local diag_prev = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))

	if #diagnostics == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	local found_prev_diag = nil
	local last_diag_in_list = diagnostics[#diagnostics] -- Keep track of the very last diagnostic for wraparound

	-- Try to find the previous diagnostic *before* the current cursor position in the current buffer
	-- Iterate backward to easily find the "last" previous diagnostic
	for i = #diagnostics, 1, -1 do
		local diag = diagnostics[i]
		if diag.bufnr == current_buf then
			if diag.lnum < current_row or (diag.lnum == current_row and diag.col < current_col) then
				found_prev_diag = diag
				break -- Found the previous diagnostic in the current buffer
			end
		end
	end

	-- If no diagnostic found before current position in current buffer, find the last in *any* buffer before current
	if not found_prev_diag then
		for i = #diagnostics, 1, -1 do
			local diag = diagnostics[i]
			if diag.bufnr < current_buf then
				found_prev_diag = diag
				break
			elseif diag.bufnr == current_buf and diag.lnum <= current_row then
				found_prev_diag = diag
				break
			end
		end
	end

	-- If still no previous diagnostic found (meaning we are at the beginning or no diagnostics before cursor),
	-- wrap around to the very last diagnostic in the entire list.
	if not found_prev_diag then
		found_prev_diag = last_diag_in_list
	end

	vim.api.nvim_set_current_buf(found_prev_diag.bufnr)
	vim.api.nvim_win_set_cursor(0, { found_prev_diag.lnum + 1, found_prev_diag.col })
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
