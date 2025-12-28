return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			local keymaps = require("core.keymaps")

			wk.setup({
				filter = function(mapping)
					return keymaps.is_custom(mapping.mode or "n", mapping.lhs)
				end,
			})

			-- Optional: register common top-level groups so the menu looks nice
			wk.add({
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>b", group = "buffers" },
				{ "<leader>k", group = "keymaps" },
			})
		end,
	},
}
