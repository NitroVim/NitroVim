# Advanced Features

NitroVim includes deep integrations for modern development workflows.

## AI Integration (GitHub Copilot)

Integrated via `copilot.lua` and `CopilotChat.nvim`.
- Suggests code in real-time.
- Interactive chat for refactoring and assistance.

## Debugging (DAP)

Using `nvim-dap` and `nvim-dap-ui`.
- Full-featured debugger within Neovim.
- Support for multiple languages via Mason.

## Dynamic UI

- **Transparent Mode**: Enabled via `transparent.nvim` for consistent aesthetics.
- **Smear Cursor**: Fluid cursor animations for better focus.
- **Mini Indent**: Clean and subtle indentation markers.

## Specialized Editing

- **NitroLearn**: An interactive learning dashboard accessible via `:NitroLearn`. It helps you master both standard Vim motions and the specialized NitroVim keymaps.
- **Snippets**: Powered by `Luasnip` and `friendly-snippets`. Use `<C-k>` to expand and jump, and `<C-j>` to go back.
- **Venn Mode**: Draw ASCII boxes and diagrams directly in Neovim.
- **Text Case**: Batch convert strings between camelCase, snake_case, etc., with Telescope integration.
- **NuGet Gallery**: Manage .NET packages directly from the editor.
- **Render Markdown**: Premium rendering of Markdown files within the buffer.

## Diagnostics

- **Lspsaga**: Enhanced LSP UI for code actions, hover, and definition peeking.
- **Tiny Inline Diagnostic**: Elegant and non-intrusive inline diagnostic messages.
