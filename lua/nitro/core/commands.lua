vim.api.nvim_create_user_command(
  "MkDir",
  function(opts)
    local dir = opts.args
    if dir == "" then
      print("Please provide a folder path!")
      return
    end
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
      print("Folder created: " .. dir)
    else
      print("Folder already exists: " .. dir)
    end
  end,
  { nargs = 1 }
)

vim.api.nvim_create_user_command("CloseAllBuffers", function()
  local current_buf = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  vim.notify("All buffers except the current one have been deleted", vim.log.levels.INFO)
end, { nargs = 0 })

vim.api.nvim_create_user_command('VTerm', function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local n = tonumber(opts.args)
  if not n or n < 1 then
    print("Number of terminals must be >= 1")
    return
  end

  local max_terminals = 4
  if n > max_terminals then
    print("Maximum terminals is " .. max_terminals)
    return
  end

  for i = 1, n do
    local term = Terminal:new({
      direction = "horizontal",
      size = 15,
      close_on_exit = false,
    })
    term:toggle()
  end
end, { nargs = 1 })
