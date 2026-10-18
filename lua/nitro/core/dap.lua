local M = {}

function M.setup_dapui()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    vim.defer_fn(function()
      if not dap.session() then
        dapui.close()
      end
    end, 1000)
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    vim.defer_fn(function()
      if not dap.session() then
        dapui.close()
      end
    end, 1000)
  end

  vim.keymap.set("n", "<leader>du", function()
    dapui.toggle()
  end, { desc = "DAP Toggle UI" })
end

M.keys = {
  {
    "<F5>",
    function()
      require("dap").continue()
    end,
    desc = "DAP Continue",
  },
  {
    "<F10>",
    function()
      require("dap").step_over()
    end,
    desc = "DAP Step Over",
  },
  {
    "<leader>dn",
    function()
      require("dap").step_over()
    end,
    desc = "DAP Step Over",
  },
  {
    "<F11>",
    function()
      require("dap").step_into()
    end,
    desc = "DAP Step Into",
  },
  {
    "<leader>di",
    function()
      require("dap").step_into()
    end,
    desc = "DAP Step Into",
  },
  {
    "<F12>",
    function()
      require("dap").step_out()
    end,
    desc = "DAP Step Out",
  },
  {
    "<leader>do",
    function()
      require("dap").step_out()
    end,
    desc = "DAP Step Out",
  },
  {
    "<leader>dc",
    function()
      require("dap").continue()
    end,
    desc = "DAP Continue",
  },
  {
    "<leader>db",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "DAP Toggle Breakpoint",
  },
  {
    "<leader>dB",
    function()
      require("dap").clear_breakpoints()
      vim.notify("All breakpoints cleared", vim.log.levels.INFO)
    end,
    desc = "DAP Clear Breakpoints",
  },
  {
    "<leader>dl",
    function()
      local bps = require("dap").list_breakpoints()
      if not bps or vim.tbl_isempty(bps) then
        vim.notify("No breakpoints set", vim.log.levels.INFO)
        return
      end
      vim.notify(vim.inspect(bps), vim.log.levels.INFO)
    end,
    desc = "DAP List Breakpoints",
  },
  {
    "<leader>dr",
    function()
      require("dap").repl.open()
    end,
    desc = "DAP Open REPL",
  },
}

return M
