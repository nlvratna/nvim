local diag_next = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()

	-- If no diagnostics, notify and return
	if #diagnostics == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	-- Find the current diagnostic index
	local current_index = nil
	for idx, diag in ipairs(diagnostics) do
		if current_buf == diag.bufnr then
			-- Check for the current diagnostic in the same buffer
			current_index = idx
			break
		end
	end

	-- If no diagnostics in current buffer, wrap around to the first diagnostic
	if not current_index then
		current_index = 1
	end

	-- Jump to the next diagnostic in the list with wraparound
	local next_index = current_index + 1
	if next_index > #diagnostics then
		-- Wrap around to the first diagnostic if the end of the list is reached
		next_index = 1
	end

	local next_diag = diagnostics[next_index]

	vim.api.nvim_set_current_buf(next_diag.bufnr)

	-- Jump to diagnostic and show float using the proper jump function
	vim.diagnostic.jump({ count = 1, float = true })
end

local diag_prev = function()
	local diagnostics = vim.diagnostic.get()
	local current_buf = vim.api.nvim_get_current_buf()

	-- If no diagnostics, notify and return
	if #diagnostics == 0 then
		vim.notify("No diagnostics available", vim.log.levels.WARN)
		return
	end

	-- Find the current diagnostic index
	local current_index = nil
	for idx, diag in ipairs(diagnostics) do
		if current_buf == diag.bufnr then
			-- Check for the current diagnostic in the same buffer
			current_index = idx
			break
		end
	end
	-- If no diagnostics in current buffer, wrap around to the last diagnostic
	if not current_index then
		current_index = #diagnostics
	end

	-- Jump to the previous diagnostic in the list with wraparound
	local prev_index = current_index - 1
	if prev_index < 1 then
		-- Wrap around to the last diagnostic if the beginning of the list is reached
		prev_index = #diagnostics
	end

	local prev_diag = diagnostics[prev_index]
	vim.api.nvim_set_current_buf(prev_diag.bufnr)
	vim.diagnostic.jump({ count = -1, float = true })
end
vim.keymap.set("n", "[d", function()
	diag_next()
end)
vim.keymap.set("n", "]d", function()
	diag_prev()
end)
