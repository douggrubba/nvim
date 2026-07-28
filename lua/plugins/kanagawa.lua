return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			require("kanagawa").setup({
				transparent = true,
				terminalColors = true,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						-- Keep popups readable over Alacritty's translucent background.
						NormalFloat = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
						FloatBorder = { fg = theme.ui.bg_m4, bg = theme.ui.bg_m3 },
						FloatTitle = { fg = theme.ui.special, bg = theme.ui.bg_m3, bold = true },
						LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
						MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},
}
