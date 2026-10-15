local M = {}

local function find_csproj()
  local cwd = vim.fn.getcwd()
  local current = vim.api.nvim_buf_get_name(0)
  local search_from = current ~= "" and vim.fs.dirname(current) or cwd

  return vim.fs.find(function(name)
    return name:match("%.csproj$") ~= nil
  end, { path = search_from, upward = true })[1]
end

local function resolve_program()
  local cwd = vim.fn.getcwd()
  local csproj = find_csproj()

  local function build_debug_if_needed(project_file)
    if not project_file then
      return
    end

    local result = vim.fn.system({ "dotnet", "build", project_file, "-c", "Debug" })
    if vim.v.shell_error ~= 0 then
      error("dotnet build failed:\n" .. result)
    end
  end

  local default_input = cwd .. "/bin/Debug/"
  if csproj then
    local project_dir = vim.fs.dirname(csproj)
    local project_name = vim.fn.fnamemodify(csproj, ":t:r")
    local dll_candidates = vim.fn.glob(project_dir .. "/bin/Debug/**/" .. project_name .. ".dll", false, true)
    if #dll_candidates == 0 then
      build_debug_if_needed(csproj)
      dll_candidates = vim.fn.glob(project_dir .. "/bin/Debug/**/" .. project_name .. ".dll", false, true)
    end
    default_input = dll_candidates[1] or (project_dir .. "/bin/Debug/")
  end

  local path = vim.fn.input("Path to dll: ", default_input, "file")
  if path == nil or path == "" then
    error("DAP launch cancelled: no DLL path provided")
  end

  local resolved = vim.fn.fnamemodify(path, ":p")
  if not resolved:match("%.dll$") then
    error("DAP launch requires a .dll file")
  end

  if vim.fn.filereadable(resolved) ~= 1 then
    error("DLL not found: " .. resolved .. " (build the project first)")
  end

  return resolved
end

local function resolve_cwd()
  local csproj = find_csproj()
  if csproj then
    return vim.fs.dirname(csproj)
  end

  return "${workspaceFolder}"
end

local function resolve_netcoredbg()
  local data = vim.fn.stdpath("data")
  local candidates = {
    data .. "/mason/bin/netcoredbg",
    data .. "/mason/packages/netcoredbg/netcoredbg",
    data .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  if vim.fn.executable("netcoredbg") == 1 then
    return "netcoredbg"
  end

  return nil
end

function M.setup_dap()
  local dap = require("dap")

  dap.adapters.coreclr = function(callback)
    local command = resolve_netcoredbg()
    if not command then
      vim.notify(
        "netcoredbg not found. Install with :MasonInstall netcoredbg or add it to PATH.",
        vim.log.levels.ERROR
      )
      return
    end

    callback({
      type = "executable",
      command = command,
      args = { "--interpreter=vscode" },
    })
  end

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "Launch - netcoredbg (Stop at entry)",
      request = "launch",
      program = resolve_program,
      cwd = resolve_cwd,
      stopAtEntry = true,
      justMyCode = false,
      requireExactSource = false,
    },
    {
      type = "coreclr",
      name = "Launch - netcoredbg",
      request = "launch",
      program = resolve_program,
      cwd = resolve_cwd,
      stopAtEntry = false,
      justMyCode = false,
      requireExactSource = false,
    },
  }
end

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

local function continue_with_default_config()
  local dap = require("dap")

  if dap.session() then
    dap.continue()
    return
  end

  local ft = vim.bo.filetype
  local configs = dap.configurations[ft]

  if ft == "cs" and configs and #configs > 0 then
    local default_index = vim.g.dap_default_cs_config_index or 2
    local config = configs[default_index] or configs[1]
    dap.run(config)
    return
  end

  dap.continue()
end

M.keys = {
  {
    "<F5>",
    function()
      local uv = vim.uv or vim.loop
      local now = uv.now()
      local last = vim.g._dap_last_f5_at or 0

      if now - last < 350 then
        return
      end

      vim.g._dap_last_f5_at = now
      continue_with_default_config()
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
      continue_with_default_config()
    end,
    desc = "DAP Continue",
  },
  {
    "<leader>ds",
    function()
      require("dap").continue()
    end,
    desc = "DAP Select Configuration",
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
