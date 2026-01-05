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
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
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
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit Neovim" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
map("n", "gd", function()
	vim.cmd("vsplit")
	vim.lsp.buf.definition({ reuse_win = false })
end, { desc = "Go to definition in split" })
map("n", "<leader>ky", function()
	require("which-key").show()
end, { desc = "Show keymaps" })

return M
