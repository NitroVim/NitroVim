local map = vim.keymap.set

-- File Explorer (NvimTree)
map("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle File Explorer" })
map("n", "<leader>h", ":NvimTreeFocus<CR>", { noremap = true, silent = true, desc = "Focus File Explorer" })

-- Terminal (ToggleTerm)
local function toggle_term_bottom()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd l")
  end
  vim.cmd("ToggleTerm direction=horizontal size=15")
end

map("n", "<leader>t", toggle_term_bottom, { noremap = true, silent = true, desc = "Toggle Terminal Bottom" })

map("t", "<leader>t", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.cmd("ToggleTerm")
  if vim.fn.bufexists("#") == 1 then
    vim.cmd("wincmd p")
  end
end, { noremap = true, silent = true, desc = "Toggle Terminal Bottom" })

-- Terminal Focus Toggle
map("n", "<leader>ft", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd l")
  end
  local term_buf = vim.fn.bufnr("term://")
  if term_buf ~= -1 and vim.fn.bufwinnr(term_buf) ~= -1 then
    vim.cmd("wincmd p")
  else
    vim.cmd("ToggleTerm direction=horizontal size=15")
  end
end, { noremap = true, silent = true, desc = "Toggle Terminal/Editor Focus" })

map("t", "<leader>ft", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.cmd("wincmd p")
end, { noremap = true, silent = true, desc = "Toggle Terminal/Editor Focus" })

-- Editor Navigation
map("n", "<leader>g", ":wincmd p<CR>", { noremap = true, silent = true, desc = "Focus Editor" })
map("n", "<leader>k", "<Cmd>bnext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
map("n", "<leader>j", "<Cmd>bprevious<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })

-- Trouble (Diagnostics & Lists)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ..." })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Code formatting
map("n", "<leader>f", function()
  vim.lsp.buf.format()
end, { noremap = true, silent = true, desc = "Format Code" })

-- Lspsaga
map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
map("n", "F", "<cmd>Lspsaga code_action<CR>")
map("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
map("n", "gr", "<cmd>Lspsaga finder<CR>")
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
