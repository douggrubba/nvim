return {
  -- mason (installs servers)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  -- mason <-> lspconfig bridge (installs + maps server names)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "ts_ls",
          "intelephense",
          "sqlls",
          "eslint",
          "tailwindcss",
          "cssls",
          "html",
          "jsonls",
        }, -- <-- ts_ls, not tsserver
      })
    end,
  },

  -- lspconfig (config glue)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("config.lsp")
    end,
  },
}
