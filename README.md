# Neovim Config Bootstrap

This repo lives at `~/.config/nvim` and contains everything except the external tooling Lazy.nvim and the CLI utilities that the plugins expect. Follow the steps below whenever you set up a new machine.

## Bootstrap on a New Machine
- Clone the repo directly to `~/.config/nvim` (or symlink it there if you keep your dotfiles elsewhere). `git clone git@github.com:<you>/nvim-config.git ~/.config/nvim`
- `init.lua` already includes the Lazy.nvim bootstrap snippet (the `git clone folke/lazy.nvim --branch=stable` block). Leave that untouched so a clean machine can pull Lazy automatically.
- Install the dependencies listed in the next section.
- Run Neovim in headless mode once to install/compile all plugins: `nvim --headless "+Lazy! sync" +qa`
- Open Neovim normally. Mason will finish installing the configured language servers (`lua_ls`, `gopls`, `ts_ls`, `intelephense`, `sqlls`, `eslint`, `tailwindcss`, `cssls`, `html`, `jsonls`) on first launch, and Treesitter will compile the Lua/Vim plus web/PHP/SQL parser set.

## System Dependencies
Even with Mason and Lazy handling most downloads, these tools are expected to exist on the system:

- `git` – required for the Lazy.nvim bootstrap and for plugin downloads.
- `ripgrep (rg)` – used by `fzf-lua` for `live_grep` and other text-search pickers.
- `fzf` – provides the fuzzy finder backend used by `fzf-lua`.
- `Node.js` + `npm` – runtime for `ts_ls` (typescript-language-server), `eslint`, `tailwindcss-language-server`, `prettier`, and installing `tree-sitter-cli`.
- `tree-sitter-cli` (`npm install -g tree-sitter-cli`) – needed by `nvim-treesitter` when compiling/updating parsers.
- `build-essential` (gcc, make, etc.) – compilers and build tools required for Treesitter parser builds.
- `Go` toolchain – supplies `gofmt` for Conform.nvim and allows `gopls` (installed via Mason) to work against Go modules.
- `stylua` – CLI formatter Conform.nvim uses for Lua buffers.
- `prettier` – CLI formatter for JavaScript/TypeScript/React/JSON/HTML/CSS buffers.
- Any other formatters or LSP binaries you add to `lua/plugins` or configure via Mason in the future (e.g., additional language servers, linters, formatters). Mason can install most of them, but keep a note here if something must be installed manually.
- `pint` – PHP formatter used by Conform.nvim. Install via Composer (`composer global require laravel/pint`) and ensure the binary is on `PATH`.
- `sqlfluff` – SQL formatter used by Conform.nvim. Install via `pipx install sqlfluff` (or your preferred package manager) and keep its executable on `PATH`.

## Language Coverage & Tooling
- **Lua** – `lua_ls` for LSP, `stylua` for formatting, Treesitter parser installed via `nvim-treesitter`.
- **Go** – `gopls` for language features and `gofmt` via Conform.nvim.
- **JavaScript / TypeScript / React** – `ts_ls` plus `eslint` and `tailwindcss` servers, Treesitter parsers for `javascript`, `typescript`, and `tsx`, and `prettier` for formatting.
- **Web stack (JSON/CSS/HTML)** – `jsonls`, `cssls`, and `html` servers, Treesitter parsers for each language, `prettier` formatting, and Tailwind IntelliSense for CSS utility classes.
- **PHP** – `intelephense` LSP support, Treesitter parser, and CLI formatting via `pint`.
- **SQL** – `sqlls` provides LSP features, the SQL Treesitter parser is installed, and formats run through `sqlfluff`.
- **Snippets & completion** – `nvim-cmp` now pulls suggestions from LSP, LuaSnip snippets (including `friendly-snippets`), buffers, and filesystem paths for a fuller completion experience.

Keep this list updated whenever you add plugins that rely on external binaries so future bootstraps stay painless.

## Keyboard Shortcuts
Leader is mapped to `<Space>`. Core keybindings from `lua/core/keymaps.lua`:

- `Space`+`f` (normal) – format the current buffer via Conform.nvim.
- `<C-s>` (normal/insert) – write the current buffer without leaving insert mode.
- `jj` (insert) – exit insert mode quickly.
- `<C-h/j/k/l>` (normal) – hop across window splits without `Ctrl+W`.
- `<` / `>` (visual) – indent/outdent while keeping the selection highlighted.
- `p` (visual) – paste without overriding the unnamed register.
- `Space`+`nh` (normal) – clear the last search highlight.
- `Space`+`bn` / `Space`+`bp` / `Space`+`bd` (normal) – cycle to the next/prev buffer in the other split (or current if only one), or delete the current one.
- `Space`+`wn` / `Space`+`wp` (normal) – move to the next/prev split.
- `Space`+`wc` (normal) – close the current split.
- `[d` / `]d` (normal) – jump to previous/next diagnostic; `Space`+`e` opens the diagnostic float.

Plugin-specific mappings live with their respective specs in `lua/plugins`. Current custom bindings include:

- `Space`+`ff` (normal mode) – trigger `FzfLua files` to search tracked files.
- `Space`+`fg` (normal mode) – run `FzfLua live_grep` to search across the repo with ripgrep.
- `Space`+`fb` (normal mode) – list open buffers via `FzfLua buffers`.
- `Space`+`fh` (normal mode) – open Neovim help tags using `FzfLua help_tags`.
- `Space`+`fr` (normal mode) – revisit recently opened files through `FzfLua oldfiles`.
