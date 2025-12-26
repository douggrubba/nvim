# Neovim Config Bootstrap

This repo lives at `~/.config/nvim` and contains everything except the external tooling Lazy.nvim and the CLI utilities that the plugins expect. Follow the steps below whenever you set up a new machine.

## Bootstrap on a New Machine
- Clone the repo directly to `~/.config/nvim` (or symlink it there if you keep your dotfiles elsewhere). `git clone git@github.com:<you>/nvim-config.git ~/.config/nvim`
- `init.lua` already includes the Lazy.nvim bootstrap snippet (the `git clone folke/lazy.nvim --branch=stable` block). Leave that untouched so a clean machine can pull Lazy automatically.
- Install the dependencies listed in the next section.
- Run Neovim in headless mode once to install/compile all plugins: `nvim --headless "+Lazy! sync" +qa`
- Open Neovim normally. Mason will finish installing `lua_ls`, `gopls`, and `ts_ls` on first launch, and Treesitter will compile the specified parsers.

## System Dependencies
Even with Mason and Lazy handling most downloads, these tools are expected to exist on the system:

- `git` – required for the Lazy.nvim bootstrap and for plugin downloads.
- `ripgrep (rg)` – used by `fzf-lua` for `live_grep` and other text-search pickers.
- `fzf` – provides the fuzzy finder backend used by `fzf-lua`.
- `Node.js` + `npm` – runtime for `ts_ls` (typescript-language-server), `prettier`, and installing `tree-sitter-cli`.
- `tree-sitter-cli` (`npm install -g tree-sitter-cli`) – needed by `nvim-treesitter` when compiling/updating parsers.
- `build-essential` (gcc, make, etc.) – compilers and build tools required for Treesitter parser builds.
- `Go` toolchain – supplies `gofmt` for Conform.nvim and allows `gopls` (installed via Mason) to work against Go modules.
- `stylua` – CLI formatter Conform.nvim uses for Lua buffers.
- `prettier` – CLI formatter for JavaScript/TypeScript/JSON/HTML/CSS buffers.
- Any other formatters or LSP binaries you add to `lua/plugins` or configure via Mason in the future (e.g., additional language servers, linters, formatters). Mason can install most of them, but keep a note here if something must be installed manually.

Keep this list updated whenever you add plugins that rely on external binaries so future bootstraps stay painless.
