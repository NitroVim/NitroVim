require("nvim-treesitter").setup({
  ensure_installed = {
    "c",
    "cpp",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "xml",
    "css",
    "json",
    "c_sharp",
    "vue",
    "astro",
    "markdown",
    "markdown_inline",
    "python",
    "fsharp"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})
