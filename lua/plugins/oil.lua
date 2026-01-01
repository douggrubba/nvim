local sidebar_state = require("config.sidebar_state")

return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return {
				default_file_explorer = true,
				keymaps = {
					["<CR>"] = {
						callback = function()
							sidebar_state.select_entry()
						end,
						desc = "Open entry in main window",
					},
					["<C-s>"] = {
						callback = function()
							sidebar_state.select_entry({ vertical = true })
						end,
						desc = "Open entry in vertical split",
					},
					["<C-h>"] = {
						callback = function()
							sidebar_state.select_entry({ horizontal = true })
						end,
						desc = "Open entry in horizontal split",
					},
					["<C-t>"] = {
						callback = function()
							sidebar_state.select_entry({ tab = true })
						end,
						desc = "Open entry in new tab",
					},
				},
			}
		end,
		keys = {
			{
				"<leader>o",
				function()
					local original_win = vim.api.nvim_get_current_win()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "oil" then
							sidebar_state.sidebar_closed(win)
							if #vim.api.nvim_tabpage_list_wins(0) <= 1 then
								vim.api.nvim_set_current_win(win)
								require("oil").close()
							else
								vim.api.nvim_win_close(win, true)
							end
							if vim.api.nvim_win_is_valid(original_win) then
								vim.api.nvim_set_current_win(original_win)
							end
							return
						end
					end

					vim.cmd("topleft vsplit")
					local sidebar_win = vim.api.nvim_get_current_win()
					require("oil").open()
					vim.api.nvim_win_set_width(sidebar_win, 30)
					sidebar_state.set_sidebar(sidebar_win, original_win)
				end,
				desc = "Toggle Oil sidebar",
			},
		},
	},
}
