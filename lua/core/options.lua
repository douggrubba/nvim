local M = {}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

vim.opt.guicursor = table.concat({
	"n-v-c:block-Cursor/lCursor-blinkwait250-blinkon500-blinkoff300",
	"i-ci-ve:ver25-CursorInsert/lCursorInsert-blinkwait250-blinkon500-blinkoff300",
	"r-cr:hor20-CursorReplace/lCursorReplace-blinkwait250-blinkon500-blinkoff300",
	"o:hor50",
}, ",")

local function set_cursor_highlights()
	local background = "#1f1f28"
	vim.api.nvim_set_hl(0, "Cursor", { bg = "#c8c093", fg = background })
	vim.api.nvim_set_hl(0, "CursorInsert", { bg = "#7e9cd8", fg = background })
	vim.api.nvim_set_hl(0, "CursorReplace", { bg = "#ff5d62", fg = background })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a37" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e6c384", bold = true })
end

set_cursor_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("CursorVisibility", { clear = true }),
	callback = set_cursor_highlights,
})

M.set_cursor_highlights = set_cursor_highlights

return M
