local M = {}
local tracked = {}

local function track(mode, lhs)
	if not lhs then
		return
	end
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
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })
map("v", "p", '"_dP', { desc = "Paste without overwriting clipboard" })
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
map("n", "<leader>ky", function()
	require("which-key").show({ global = false })
end, { desc = "Show keymaps" })

return M
