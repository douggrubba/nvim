return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- Supports Neovim 0.11 and the configs.setup API.
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end

      configs.setup({
        ensure_installed = {
          "lua",
          "odin",
          "vim",
          "vimdoc",
          "python",
          "php",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "css",
          "html",
          "sql",
        },
        highlight = { enable = true },
      })
    end,
  },
}
