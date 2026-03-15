# Commands

NitroVim provides a collection of custom user commands and plugin-integrated commands to enhance your workflow.

## NitroVim Specific Commands

These commands are unique to the NitroVim distribution.

| Command | Description |
| --- | --- |
| `:NitroLearn` | Opens the NitroVim learning dashboard for interactive documentation on core Vim commands and NitroVim keymaps. |
| `:FileExplorer {left/right/center}` | Opens the file tree and positions it at the specified location. |
| `:ThemeSwitch` | Opens a menu to quickly switch between the 20+ included themes. |
| `:MkDir <path>` | Recursively creates the directory at the given path. |
| `:CloseAllBuffers` | Closes all open buffers except the one currently focused. |
| `:VTerm <n>` | Opens a specific number of terminal windows (up to 4). |

## UI & Appearance Commands

| Command | Description |
| --- | --- |
| `:TransparentToggle` | Toggles the transparency effect for the editor. |
| `:TransparentEnable` | Enables transparency. |
| `:TransparentDisable` | Disables transparency. |

## Essential Plugin Commands

NitroVim relies on several powerful plugins that expose their own commands.

| Command | Description |
| --- | --- |
| `:Lazy` | Opens the Lazy.nvim plugin manager dashboard. |
| `:Mason` | Opens the Mason manager for LSP, DAP, and Linters. |
| `:Telescope` | Entry point for various fuzzy finding operations. |
| `:Trouble` | Toggles the diagnostics and quickfix lists. |
| `:CopilotChat` | Opens the AI Chat interface. |
| `:TSUpdate` | Updates Treesitter parsers. |
| `:LspInfo` | Shows information about the current LSP clients. |
| `:Gitsigns <cmd>` | Commands for git signs (blame, refresh, etc.). |
