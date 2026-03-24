require("notify").setup({
  background_colour = "#000000",
  max_width = 50
})

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local reg = vim.fn.reg_recording()
    if reg ~= "" then
      vim.notify("Recording @" .. reg, "info", { timeout = 2000 })
    end
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    local reg = vim.fn.reg_recording()
    if reg ~= "" then
      vim.notify("Recording @" .. reg .. " stopped", "info", { timeout = 2000 })
    else
      vim.notify("Recording stopped", "info", { timeout = 2000 })
    end
  end,
})
