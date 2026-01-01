local M = {
	sidebar_win = nil,
	main_win = nil,
}

local function win_is_valid(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function is_oil_window(win)
	if not win_is_valid(win) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].filetype == "oil"
end

function M.set_sidebar(sidebar_win, main_win)
	if win_is_valid(sidebar_win) then
		M.sidebar_win = sidebar_win
	else
		M.sidebar_win = nil
	end
	if win_is_valid(main_win) then
		M.main_win = main_win
	end
end

function M.sidebar_closed(winid)
	if winid and M.sidebar_win == winid then
		M.sidebar_win = nil
	end
end

function M.get_sidebar_win()
	if win_is_valid(M.sidebar_win) then
		return M.sidebar_win
	end
	M.sidebar_win = nil
	return nil
end

function M.get_main_win()
	local sidebar = M.get_sidebar_win()
	if win_is_valid(M.main_win) and M.main_win ~= sidebar and not is_oil_window(M.main_win) then
		return M.main_win
	end
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if win ~= sidebar and not is_oil_window(win) then
			M.main_win = win
			return win
		end
	end
	return nil
end

function M.focus_main_window()
	local win = M.get_main_win()
	if not win then
		return false
	end
	vim.api.nvim_set_current_win(win)
	return true
end

function M.open_buffer_in_main(bufnr)
	local win = M.get_main_win()
	if not win then
		return false
	end
	vim.api.nvim_win_set_buf(win, bufnr)
	vim.api.nvim_set_current_win(win)
	return true
end

function M.select_entry(opts)
	local oil = require("oil")
	opts = opts or {}
	opts.handle_buffer_callback = function(bufnr)
		if not M.open_buffer_in_main(bufnr) then
			vim.api.nvim_win_set_buf(0, bufnr)
		end
	end
	oil.select(opts)
end

function M.run_in_main_window(fn)
	if type(fn) ~= "function" then
		return
	end
	local win = M.get_main_win()
	if not win then
		fn()
		return
	end
	local current = vim.api.nvim_get_current_win()
	if current == win then
		fn()
		return
	end
	vim.api.nvim_set_current_win(win)
	fn()
end

return M
