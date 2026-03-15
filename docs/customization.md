# Customization & Extension Guide

NitroVim is designed to be highly modular and customizable. This guide provides detailed instructions on how to tailor the distribution to your specific needs.

## 1. Changing Editor Options

Core Neovim options (tab width, line numbers, performance settings) are managed in:
`lua/nitro/core/options.lua`

**Example: Switch to Relative Line Numbers**
```lua
vim.opt.relativenumber = true
```

## 2. Appearance & Themes

NitroVim includes 20+ premium themes. You can switch them interactively with `:ThemeSwitch`.

### Persistent Theme Configuration
To change the default theme permanently, modify `lua/nitro/ui/colorschemes.lua` or use the `:ThemeSwitch` command which saves your choice to `theme.json`.

### Transparency
You can toggle transparency with `:TransparentToggle`. Detailed group settings are in `lua/nitro/ui/transparent.lua`.

## 3. Customizing the UI

### Dashboard (Start Screen)
Modify `lua/nitro/ui/dashboard.lua` to change:
- **Header**: The ASCII art shown at the top.
- **Quotes**: The random tips shown at the bottom.
- **Center Actions**: The shortcut buttons (New File, Recent Files, etc.).

### Statusline (Lualine)
Configuration is in `lua/nitro/ui/statusline.lua`. You can:
- Change the **Mode Icon** (`󱐋`).
- Add/remove sections like `branch`, `diagnostics`, or the `clock`.

### Bufferline (Tabs)
Configuration is in `lua/nitro/ui/tabs.lua`.
- **Separator Style**: Change to `slant`, `padded`, or `block`.
- **Offsets**: Configure how the tabline behaves with sidebars like NvimTree.

## 4. Keymaps & Shortcuts

Global shortcuts are in `lua/nitro/core/keymaps.lua`. 

**Example: Custom Mapping with Description**
```lua
map("n", "<leader>w", ":w<CR>", { desc = "Save File" })
```

## 5. Adding & Configuring Plugins

Manage plugins in `lua/nitro/plugins/plugins.lua`.

### Installing a new plugin
```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = { ... }
}
```

### Customizing Autocompletion (Cmp)
Icons and behavior for the completion menu are in `lua/nitro/core/cmp.lua`. You can change the `kind_icons` table to use your preferred symbols.

## 6. Language Support (LSP)

NitroVim uses Mason for easy management.
1.  **Install**: Use `:Mason` to install new servers.
2.  **Enable**: Add the server name to the `vim.lsp.enable({...})` list in `lua/nitro/lsp/lsp.lua`.
3.  **Formatting**: Auto-formatting on save is enabled by default in `lsp.lua`.

## 7. Snippets & Templates
NitroVim uses `Luasnip`. You can find the main snippet logic in `lua/nitro/snippets/snippets.lua`. Custom snippets can be added to the `lua/nitro/snippets/custom/` directory.

## 8. Auto-Save Features
Adjust thresholds, messages, and debounce delays in `lua/nitro/plugins/plugins.lua` under the `auto-save.nvim` specification.
