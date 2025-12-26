vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
