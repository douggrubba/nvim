return {
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      require("eldritch").setup({
        transparent = true,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
      vim.cmd.colorscheme("eldritch")
      -- Ensure backgrounds are fully transparent after the colorscheme loads.
      local clear_bg = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "FoldColumn",
        "LineNr",
        "EndOfBuffer",
      }
      for _, group in ipairs(clear_bg) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
      vim.api.nvim_set_hl(0, "Comment", { italic = true })
    end,
  },
}
