local M = {}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.guicursor = table.concat({
	"n-v-c:block-Cursor/lCursor-blinkwait250-blinkon500-blinkoff300",
	"i-ci-ve:ver25-CursorInsert/lCursorInsert-blinkwait250-blinkon500-blinkoff300",
	"r-cr:hor20-CursorReplace/lCursorReplace-blinkwait250-blinkon500-blinkoff300",
	"o:hor50",
}, ",")

local function set_cursor_highlights()
	vim.api.nvim_set_hl(0, "Cursor", { bg = "#f7c67f", fg = "#11121d" })
	vim.api.nvim_set_hl(0, "CursorInsert", { bg = "#8be9fd", fg = "#11121d" })
	vim.api.nvim_set_hl(0, "CursorReplace", { bg = "#ff6e7f", fg = "#11121d" })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#202532" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f7c67f", bold = true })
end

set_cursor_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("CursorVisibility", { clear = true }),
	callback = set_cursor_highlights,
})

M.set_cursor_highlights = set_cursor_highlights

return M
