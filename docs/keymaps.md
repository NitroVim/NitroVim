# Keymaps

This document provides a **complete and comprehensive** list of all keybindings configured in NitroVim. The leader key is `<Space>`.

## General & Navigation

| Key | Description |
| --- | --- |
| `<leader>f` | Format current buffer (LSP) |
| `<leader>k` | Next buffer |
| `<leader>j` | Previous buffer |
| `<leader>g` | Focus editor (switch from NvimTree/Terminal) |
| `<C-h>` | Move to window left |
| `<C-j>` | Move to window down |
| `<C-k>` | Move to window up |
| `<C-l>` | Move to window right |

## File Explorer (NvimTree)

| Key | Description |
| --- | --- |
| `<leader>e` | Toggle File Explorer |
| `<leader>o` | Focus File Explorer |
| `<leader>r` | Refresh File Explorer |
| `<leader>n` | Find current file in File Explorer |
| `<leader>h` | Focus File Explorer (alternative) |

## Fuzzy Finder (Telescope)

| Key | Description |
| --- | --- |
| `<leader>ff` | Find Files |
| `<leader>fg` | Live Grep (Search text) |
| `<leader>fb` | List Open Buffers |
| `<leader>fh` | Help Tags |

## Terminal (ToggleTerm)

| Key | Description |
| --- | --- |
| `<leader>t` | Toggle horizontal terminal |
| `<leader>ft` | Toggle focus between Terminal and Editor |
| `<leader>lg` | Toggle LazyGit (floating) |
| `<C-\>` | Toggle floating terminal |

## AI / Copilot

| Key | Description |
| --- | --- |
| `<leader>ai` | Toggle AI Panel (Copilot Chat) |
| `<leader>ap` | Ask AI Prompt (interactive input) |

## Snippets (Luasnip)

| Key | Description |
| --- | --- |
| `<C-k>` | Expand snippet or jump forward |
| `<C-j>` | Jump backward |
| `<C-l>` | Cycle through choices (if available) |

## LSP & Code Intelligence

| Key | Description |
| --- | --- |
| `K` | Hover Documentation / Lspsaga hover |
| `F` | Code Action (Lspsaga) |
| `gd` | Go to Definition / Peek Definition |
| `gr` | Show References / Finder |
| `gi` | Go to Implementation |
| `<leader>ca`| Code Action (Lspsaga) |
| `<leader>rn`| Rename Symbol |
| `[d` | Previous Diagnostic |
| `]d` | Next Diagnostic |

## Debugging (DAP)

| Key | Description |
| --- | --- |
| `<F5>` | Continue / Start Debugging |
| `<F10>` | Step Over |
| `<F11>` | Step Into |
| `<F12>` | Step Out |
| `<leader>dc` | Continue |
| `<leader>db` | Toggle Breakpoint |
| `<leader>dB` | Clear All Breakpoints |
| `<leader>dl` | List Breakpoints |
| `<leader>dn` | Step Over |
| `<leader>di` | Step Into |
| `<leader>do` | Step Out |
| `<leader>ds` | Select Configuration |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |

## Testing (Neotest)

| Key | Description |
| --- | --- |
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run all tests in current file |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Open test output |

## Diagnostics & Lists (Trouble)

| Key | Description |
| --- | --- |
| `<leader>xx` | Toggle Diagnostics (Trouble) |
| `<leader>xX` | Toggle Buffer Diagnostics (Trouble) |
| `<leader>cs` | Toggle Symbols (Trouble) |
| `<leader>cl` | Toggle LSP definitions/references (Trouble) |
| `<leader>xL` | Toggle Location List (Trouble) |
| `<leader>xQ` | Toggle Quickfix List (Trouble) |

## Specialized Tools

| Key | Description |
| --- | --- |
| `<leader>v` | Toggle Venn mode (ASCII diagrams) |
| `ga.` | Open TextCase Telescope |
| `]h` | Next Git Hunk |
| `[h` | Previous Git Hunk |
