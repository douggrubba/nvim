local M = {}
local tracked = {}

local function normalize(lhs)
	if type(lhs) ~= "string" then
		return lhs
	end
	return vim.api.nvim_replace_termcodes(lhs, true, true, true)
end

local function track(mode, lhs)
	if not lhs then
		return
	end
	lhs = normalize(lhs)
	local modes = type(mode) == "table" and mode or { mode }
	for _, m in ipairs(modes) do
		tracked[(m or "") .. ":" .. lhs] = true
	end
end

local function map(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, opts)
	track(mode, lhs)
end

local function peek_definition()
	local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
	if #clients == 0 then
		vim.notify("No LSP definition provider attached.", vim.log.levels.WARN)
		return
	end

	local origin_win = vim.api.nvim_get_current_win()
	local params = function(client)
		return vim.lsp.util.make_position_params(origin_win, client.offset_encoding or "utf-16")
	end

	vim.lsp.buf_request_all(0, "textDocument/definition", params, function(results)
		local locations = {}

		for client_id, response in pairs(results) do
			local client = vim.lsp.get_client_by_id(client_id)
			local offset_encoding = (client and client.offset_encoding) or "utf-16"
			local result = response.result
			if result then
				if result.uri or result.targetUri then
					table.insert(locations, { location = result, offset_encoding = offset_encoding })
				else
					for _, item in ipairs(result) do
						table.insert(locations, { location = item, offset_encoding = offset_encoding })
					end
				end
			end
		end

		if #locations == 0 then
			vim.notify("No definition found.", vim.log.levels.INFO)
			return
		end

		local item = locations[1]
		local location = item.location
		local uri = location.targetUri or location.uri
		local range = location.targetSelectionRange or location.targetRange or location.range
		if not uri or not range then
			vim.notify("Definition location was incomplete.", vim.log.levels.WARN)
			return
		end

		local target_buf = vim.uri_to_bufnr(uri)
		vim.fn.bufload(target_buf)
		local ok_col, col =
			pcall(vim.lsp.util._get_line_byte_from_position, target_buf, range.start, item.offset_encoding)
		if not ok_col then
			col = 0
		end

		local preview_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, vim.api.nvim_buf_get_lines(target_buf, 0, -1, false))
		vim.bo[preview_buf].bufhidden = "wipe"
		vim.bo[preview_buf].buftype = "nofile"
		vim.bo[preview_buf].filetype = vim.bo[target_buf].filetype
		vim.bo[preview_buf].modifiable = false

		local columns = vim.o.columns
		local lines = vim.o.lines - vim.o.cmdheight
		local width = math.max(80, math.floor(columns * 0.82))
		local height = math.max(20, math.floor(lines * 0.72))
		width = math.min(width, columns - 4)
		height = math.min(height, lines - 4)

		local filename = vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:.")
		local line = range.start.line + 1
		local title = (" Definition: %s:%d "):format(filename, line)
		if #locations > 1 then
			title = (" Definition 1/%d: %s:%d "):format(#locations, filename, line)
		end

		local preview_win = vim.api.nvim_open_win(preview_buf, true, {
			relative = "editor",
			width = width,
			height = height,
			col = math.floor((columns - width) / 2),
			row = math.floor((lines - height) / 2),
			border = "rounded",
			style = "minimal",
			title = title,
			title_pos = "center",
		})

		vim.wo[preview_win].cursorline = true
		vim.wo[preview_win].number = true
		vim.wo[preview_win].relativenumber = false
		vim.wo[preview_win].signcolumn = "no"
		vim.wo[preview_win].wrap = false

		vim.api.nvim_win_set_cursor(preview_win, { line, col })
		vim.cmd("normal! zz")

		local function close_preview()
			if vim.api.nvim_win_is_valid(preview_win) then
				vim.api.nvim_win_close(preview_win, true)
			end
		end

		local function open_definition()
			close_preview()
			if vim.api.nvim_win_is_valid(origin_win) then
				vim.api.nvim_set_current_win(origin_win)
			end
			vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(uri)))
			vim.api.nvim_win_set_cursor(0, { line, col })
			vim.cmd("normal! zz")
		end

		vim.keymap.set(
			"n",
			"q",
			close_preview,
			{ buffer = preview_buf, nowait = true, silent = true, desc = "Close definition preview" }
		)
		vim.keymap.set(
			"n",
			"<Esc>",
			close_preview,
			{ buffer = preview_buf, nowait = true, silent = true, desc = "Close definition preview" }
		)
		vim.keymap.set(
			"n",
			"<CR>",
			open_definition,
			{ buffer = preview_buf, nowait = true, silent = true, desc = "Open definition" }
		)
	end)
end

function M.is_custom(mode, lhs)
	if not lhs then
		return false
	end
	lhs = normalize(lhs)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			if tracked[(m or "") .. ":" .. lhs] then
				return true
			end
		end
		return false
	end
	return tracked[(mode or "") .. ":" .. lhs] or false
end

function M.custom_mappings()
	return tracked
end

map("n", "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

map("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Leave insert mode" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })
map("n", "<leader>wn", "<C-w>w", { desc = "Next split" })
map("n", "<leader>wp", "<C-w>W", { desc = "Prev split" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close current split" })
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })
map("v", "p", '"_dP', { desc = "Paste without overwriting clipboard" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>bn", function()
	if #vim.api.nvim_list_wins() > 1 then
		vim.cmd("wincmd w")
	end
	vim.cmd("bnext")
end, { desc = "Next buffer (other window if split)" })
map("n", "<leader>bp", function()
	if #vim.api.nvim_list_wins() > 1 then
		vim.cmd("wincmd w")
	end
	vim.cmd("bprevious")
end, { desc = "Prev buffer (other window if split)" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>qq", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].modified then
			vim.notify("Unsaved buffers exist; save or close them before quitting.", vim.log.levels.WARN)
			return
		end
	end
	vim.cmd("qa")
end, { desc = "Quit Neovim if all buffers are saved" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
map("n", "gd", peek_definition, { desc = "Peek definition" })
map("n", "<leader>ky", function()
	require("which-key").show()
end, { desc = "Show keymaps" })

return M
