return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, icons
		cmd = { "FzfLua" },
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
		},
		config = function()
			require("fzf-lua").setup({
				-- defaults are good; keep it simple at first
				files = {
					-- If you prefer to include hidden files by default:
					-- fd_opts = "--type f --hidden --follow --exclude .git",
				},
				grep = {
					rg_opts = "--hidden --glob '!.git/*' --line-number --column --smart-case",
				},
				winopts = {
					border = "rounded",
				},
			})
		end,
	},
}
