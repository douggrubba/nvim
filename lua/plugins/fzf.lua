local sidebar_state = require("config.sidebar_state")

local function run_picker(method)
	return function()
		local function execute()
			require("fzf-lua")[method]()
		end
		if vim.bo.filetype == "oil" then
			sidebar_state.run_in_main_window(execute)
		else
			execute()
		end
	end
end

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, icons
		cmd = { "FzfLua" },
		keys = {
			{ "<leader>ff", run_picker("files"), desc = "Find files" },
			{ "<leader>fg", run_picker("live_grep"), desc = "Live grep" },
			{ "<leader>fb", run_picker("buffers"), desc = "Buffers" },
			{ "<leader>fh", run_picker("help_tags"), desc = "Help tags" },
			{ "<leader>fr", run_picker("oldfiles"), desc = "Recent files" },
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
