local M = {}

M.dependencies = {
  "nvim-lua/plenary.nvim",
  "antoinemadec/FixCursorHold.nvim",
  "nvim-treesitter/nvim-treesitter",
  "Issafalcon/neotest-dotnet",
  "nvim-neotest/nvim-nio",
  "haydenmeade/neotest-jest",
}

local function find_root(markers, file_path)
  local uv = vim.uv or vim.loop
  local start_path = file_path

  if not start_path or start_path == "" then
    start_path = vim.api.nvim_buf_get_name(0)
  end

  local search_from = start_path ~= "" and vim.fs.dirname(start_path) or uv.cwd()
  local match = vim.fs.find(markers, { path = search_from, upward = true })[1]

  if match then
    return vim.fs.dirname(match)
  end

  return uv.cwd()
end

local function get_jest_command(project_root)
  local commands = {
    { file = "pnpm-lock.yaml", cmd = "pnpm test --" },
    { file = "yarn.lock", cmd = "yarn test --" },
    { file = "package-lock.json", cmd = "npm test --" },
    { file = "bun.lock", cmd = "bun test" },
    { file = "bun.lockb", cmd = "bun test" },
  }

  for _, candidate in ipairs(commands) do
    local lockfile = vim.fs.find(candidate.file, { path = project_root, upward = false })[1]
    if lockfile then
      return candidate.cmd
    end
  end

  if vim.fn.executable("jest") == 1 then
    return "jest --"
  end

  return "npx jest"
end

function M.setup()
  local neotest = require("neotest")
  local adapters = {}

  if vim.fn.executable("dotnet") ~= 1 then
    vim.notify("dotnet executable not found: neotest-dotnet adapter disabled", vim.log.levels.WARN)
  else
    local has_dotnet, neotest_dotnet = pcall(require, "neotest-dotnet")
    if has_dotnet then
      table.insert(adapters, neotest_dotnet({
        dap = {
          adapter_name = "coreclr",
          args = { justMyCode = false },
        },
        discovery_root = "solution",
        dotnet_additional_args = {
          "--configuration",
          "Debug",
          "--nologo",
        },
      }))
    end
  end

  local has_jest, neotest_jest = pcall(require, "neotest-jest")
  if has_jest then
    table.insert(adapters, neotest_jest({
      jestCommand = function(file)
        local root = find_root({ "package.json", "pnpm-workspace.yaml", ".git" }, file)
        return get_jest_command(root)
      end,
      jestConfigFile = function(file)
        local root = find_root({ "package.json", "pnpm-workspace.yaml", ".git" }, file)
        return vim.fs.find({
          "jest.config.ts",
          "jest.config.js",
          "jest.config.cjs",
          "jest.config.mjs",
          "jest.config.json",
        }, { path = root, upward = true })[1]
      end,
      env = { CI = true },
      cwd = function(file)
        return find_root({ "package.json", "pnpm-workspace.yaml", ".git" }, file)
      end,
    }))
  end

  neotest.setup({
    adapters = adapters,
    diagnostic = {
      enabled = true,
    },
    summary = {
      open = "botright vsplit | vertical resize 40",
    },
    output = {
      open_on_run = "short",
    },
  })

  vim.keymap.set("n", "<leader>tn", function()
    neotest.run.run()
  end, { desc = "Run nearest test" })

  vim.keymap.set("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%"))
  end, { desc = "Run all tests in file" })

  vim.keymap.set("n", "<leader>ts", function()
    neotest.summary.toggle()
  end, { desc = "Toggle summary" })

  vim.keymap.set("n", "<leader>to", function()
    neotest.output.open({ enter = true })
  end, { desc = "Open test output" })
end

return M
