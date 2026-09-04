return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>ky", "<cmd>WhichKey n <leader><cr>", desc = "Show keymaps" },
			{ "<leader>ki", "<cmd>WhichKey i<cr>", desc = "Show insert keymaps" },
		},
		config = function()
			local wk = require("which-key")
			local keymaps = require("core.keymaps")

			wk.setup({
				filter = function(mapping)
					if keymaps.is_custom(mapping.mode or "n", mapping.lhs) then
						return true
					end

					return type(mapping.desc) == "string" and mapping.desc ~= ""
				end,
			})

			-- Optional: register common top-level groups so the menu looks nice
			wk.add({
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>b", group = "buffers" },
				{ "<leader>k", group = "keymaps" },
				{ "<leader>m", group = "harpoon" },
				{ "<Tab>", desc = "Copilot: accept suggestion", mode = "i" },
				{ "<M-w>", desc = "Copilot: accept word", mode = "i" },
				{ "<M-l>", desc = "Copilot: accept line", mode = "i" },
				{ "<M-[>", desc = "Copilot: previous suggestion", mode = "i" },
				{ "<M-]>", desc = "Copilot: next suggestion", mode = "i" },
				{ "<C-]>", desc = "Copilot: dismiss suggestion", mode = "i" },
			})
		end,
	},
}
