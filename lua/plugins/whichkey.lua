return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>ky", "<cmd>WhichKey n <leader><cr>", desc = "Show keymaps" },
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
				{ "<leader>a", group = "ai" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>l", group = "lsp" },
				{ "<leader>b", group = "buffers" },
				{ "<leader>k", group = "keymaps" },
			})
		end,
	},
}
