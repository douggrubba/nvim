# Neovim Config Bootstrap

This repo lives at `~/.config/nvim` and contains everything except the external tooling Lazy.nvim and the CLI utilities that the plugins expect. Follow the steps below whenever you set up a new machine.

## Bootstrap on a New Machine
- Clone the repo directly to `~/.config/nvim` (or symlink it there if you keep your dotfiles elsewhere). `git clone git@github.com:<you>/nvim-config.git ~/.config/nvim`
- `init.lua` already includes the Lazy.nvim bootstrap snippet (the `git clone folke/lazy.nvim --branch=stable` block). Leave that untouched so a clean machine can pull Lazy automatically.
- Install the dependencies listed in the next section.
- Run Neovim in headless mode once to install/compile all plugins: `nvim --headless "+Lazy! sync" +qa`
- Open Neovim normally. Mason will finish installing the configured language servers (`lua_ls`, `gopls`, `ts_ls`, `intelephense`, `sqlls`, `pyright`, `ruff`, `eslint`, `tailwindcss`, `cssls`, `html`, `jsonls`) on first launch, and Treesitter will compile the Lua/Vim/Python plus web/PHP/SQL parser set.

## System Dependencies
Even with Mason and Lazy handling most downloads, these tools are expected to exist on the system:

- `git` – required for the Lazy.nvim bootstrap and for plugin downloads.
- `ripgrep (rg)` – used by `fzf-lua` for `live_grep` and other text-search pickers.
- `fzf` – provides the fuzzy finder backend used by `fzf-lua`.
- `Node.js` + `npm` – runtime for `ts_ls` (typescript-language-server), `eslint`, `tailwindcss-language-server`, `prettier`, and installing `tree-sitter-cli`.
- `tree-sitter-cli` (`npm install -g tree-sitter-cli`) – needed by `nvim-treesitter` when compiling/updating parsers.
- `build-essential` (gcc, make, etc.) – compilers and build tools required for Treesitter parser builds.
- `Go` toolchain – allows `gopls` (installed via Mason) to work against Go modules. Install `goimports` with `go install golang.org/x/tools/cmd/goimports@latest` and ensure the Go bin directory is on `PATH` for Conform.nvim.
- `stylua` – CLI formatter Conform.nvim uses for Lua buffers.
- `prettier` – CLI formatter for JavaScript/TypeScript/React/JSON/HTML/CSS buffers.
- `pint` – PHP formatter used by Conform.nvim. Install via Composer (`composer global require laravel/pint`) and ensure the binary is on `PATH`.
- `sqlfluff` – SQL formatter used by Conform.nvim. Install via `pipx install sqlfluff` (or your preferred package manager) and keep its executable on `PATH`.
- `ruff` and `black` – Python formatters used by Conform.nvim. Mason installs the Ruff LSP, but the formatter executables must be on `PATH`.
- `curl` – used by the custom start buffer to fetch Huntersville weather from `wttr.in`.
- Any other formatters or LSP binaries you add to `lua/plugins` or configure via Mason in the future (e.g., additional language servers, linters, formatters). Mason can install most of them, but keep a note here if something must be installed manually.

## Current Feature Set
- **Lazy.nvim bootstrap** – `init.lua` clones Lazy.nvim automatically on a clean machine and loads every plugin spec from `lua/plugins`.
- **Kanagawa Wave theme** – transparent editor backgrounds that blend with the matching Alacritty palette, dark readable floats, Kanagawa terminal colors, italic comments, palette-matched cursor colors, a highlighted cursor line, and line/relative line numbers.
- **Custom start buffer** – opens when Neovim starts without a concrete file, shows the current time, Huntersville weather, current directory, Git branch, and full `git status` with clean/dirty highlighting.
- **Oil file sidebar** – `<Space>o` toggles a 30-column left sidebar. Opening a file from Oil targets the remembered main editing window instead of replacing the sidebar.
- **Fzf-lua search** – file, grep, buffer, help, and recent-file pickers use rounded floating windows; live grep includes hidden files while excluding `.git`, and pickers launched from Oil run against the main editing window.
- **Which-key discovery** – custom and described mappings are surfaced through which-key, with leader groups for find, git, LSP, buffers, and keymaps.
- **LSP via Mason** – Mason installs the configured language servers and `nvim-lspconfig` enables them with `nvim-cmp` capabilities.
- **Inline diagnostics** – diagnostics render as virtual text, with sign-column diagnostics disabled.
- **Completion and snippets** – `nvim-cmp` combines LSP, LuaSnip, buffer, and path sources, with `friendly-snippets` loaded lazily.
- **Formatting on save** – Conform.nvim formats on `BufWritePre` with a 500ms timeout and LSP fallback. `<Space>f` formats the current buffer manually.
- **Definition preview** – `gd` opens a large rounded floating preview of the first LSP definition; `q`/`Esc` closes it and `<Enter>` opens the definition.
- **Terminal modal** – `<Space>t` opens the configured shell in a centered floating terminal. `q` closes the terminal window and `<Esc>` leaves terminal mode.

## Language Coverage & Tooling
- **Lua** – `lua_ls` for LSP, `stylua` for formatting, Treesitter parser installed via `nvim-treesitter`.
- **Go** – `gopls` for language features and `goimports` via Conform.nvim.
- **JavaScript / TypeScript / React** – `ts_ls` plus `eslint` and `tailwindcss` servers, Treesitter parsers for `javascript`, `typescript`, and `tsx`, and `prettier` for formatting.
- **Web stack (JSON/CSS/HTML)** – `jsonls`, `cssls`, and `html` servers, Treesitter parsers for each language, `prettier` formatting, and Tailwind IntelliSense for CSS utility classes.
- **PHP** – `intelephense` LSP support, Treesitter parser, and CLI formatting via `pint`.
- **SQL** – `sqlls` provides LSP features, the SQL Treesitter parser is installed, and formats run through `sqlfluff`.
- **Python** – `pyright` for type-aware language features, `ruff` for linting, Python Treesitter highlighting, and Conform formatting through `ruff_format` with `black` as the fallback.
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
- `Space`+`h` (normal) – clear the last search highlight.
- `Space`+`bn` / `Space`+`bp` / `Space`+`bd` (normal) – cycle to the next/prev buffer in the other split (or current if only one), or delete the current one.
- `Space`+`wn` / `Space`+`wp` (normal) – move to the next/prev split.
- `Space`+`wc` (normal) – close the current split.
- `Space`+`qq` (normal) – quit Neovim only if every listed buffer is saved.
- `[d` / `]d` (normal) – jump to previous/next diagnostic; `Space`+`e` opens the diagnostic float.
- `gd` (normal) – peek the definition in a large floating preview; press `q`/`Esc` to close it or `<Enter>` to open the definition.
- `Space`+`t` (normal) – open a centered terminal modal; press `q` to close it or `<Esc>` in terminal mode to return to normal mode.

Plugin-specific mappings live with their respective specs in `lua/plugins`. Current custom bindings include:

- `Space`+`o` (normal mode) – toggle the Oil file explorer sidebar.
- In Oil: `<CR>` opens the selected entry in the main window, `<C-s>` opens a vertical split, `<C-h>` opens a horizontal split, and `<C-t>` opens a new tab.
- `Space`+`Space` (normal mode) – trigger `FzfLua files` to find files.
- `Space`+`ff` (normal mode) – trigger `FzfLua files` from the startup working directory.
- `Space`+`fg` (normal mode) – run `FzfLua live_grep` to search across the repo with ripgrep.
- `Space`+`fb` (normal mode) – list open buffers via `FzfLua buffers`.
- `Space`+`fh` (normal mode) – open Neovim help tags using `FzfLua help_tags`.
- `Space`+`fr` (normal mode) – revisit recently opened files through `FzfLua oldfiles`.
- `Space`+`ky` (normal mode) – show leader keymaps through which-key.
- `<C-Space>` (insert mode) – open the completion menu.
- `<CR>` (insert mode with completion menu visible) – confirm the selected completion item.
- `<Tab>` (insert mode) – move through the completion menu or jump forward through snippets.
- `<S-Tab>` (insert/select mode) – move backward through completion items or jump backward through snippets.
