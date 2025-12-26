-- Capabilities: add cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

-- Go
vim.lsp.config("gopls", {
  capabilities = capabilities,
})

-- TypeScript/JavaScript (new name)
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

-- Enable them
vim.lsp.enable({ "lua_ls", "gopls", "ts_ls" })

