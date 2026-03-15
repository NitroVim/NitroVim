local M = {}

local function with_right_split(action)
  local splitright = vim.o.splitright
  vim.o.splitright = true

  local ok, err = pcall(action)

  vim.o.splitright = splitright

  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

M.copilot_opts = {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

M.chat_keys = {
  {
    "<leader>ai",
    function()
      with_right_split(function()
        require("CopilotChat").toggle()
      end)
    end,
    mode = "n",
    desc = "Toggle AI Panel",
  },
  {
    "<leader>ap",
    function()
      vim.ui.input({ prompt = "Ask Copilot: " }, function(input)
        if input and input ~= "" then
          with_right_split(function()
            require("CopilotChat").ask(input)
          end)
        end
      end)
    end,
    mode = "n",
    desc = "Ask AI Prompt",
  },
}

M.chat_opts = {
  window = {
    layout = "vertical",
    width = 0.36,
  },
}

return M
