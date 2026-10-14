vim.opt.termguicolors = true
vim.opt.showtabline = 2

require("bufferline").setup({
  options = {
    mode = "buffers",
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        separator = false,
        padding = 0,
        highlight = "NvimTreeNormal",
      },
    },
  },
  highlights = {
    buffer_selected = { bold = true, italic = false },
  },
})
