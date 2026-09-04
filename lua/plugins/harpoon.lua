local keys = {
	{
		"<leader>ma",
		function()
			require("harpoon"):list():add()
		end,
		desc = "Add file to Harpoon",
	},
	{
		"<leader>mm",
		function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Open Harpoon menu",
	},
	{
		"<leader>mp",
		function()
			require("harpoon"):list():prev()
		end,
		desc = "Previous Harpoon file",
	},
	{
		"<leader>mn",
		function()
			require("harpoon"):list():next()
		end,
		desc = "Next Harpoon file",
	},
}

for index = 1, 4 do
	table.insert(keys, {
		"<leader>m" .. index,
		function()
			require("harpoon"):list():select(index)
		end,
		desc = "Open Harpoon file " .. index,
	})
end

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = keys,
		config = function()
			require("harpoon"):setup()
		end,
	},
}
