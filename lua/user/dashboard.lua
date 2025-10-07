---@diagnostic disable: undefined-global
---@type table

local dashboard = require('dashboard')

local quotes = {
  "💡 Tip: Stay in Normal mode more — that’s the Vim way!",
  "🚀 Speed comes from muscle memory, not menus.",
  "⚡ Focus on editing, not configuring. NitroVim’s got your back.",
  "🌌 Small configs, big productivity.",
  "🔥 Code fast, exit faster. :wq",
  "📖 Learn one command a day, master Vim in a year.",
  "🎯 Motion > Mouse. Always.",
}

math.randomseed(os.time())
local random_quote = quotes[math.random(#quotes)]

dashboard.setup({
  theme = 'doom',
  config = {
    header = {
      '',
      '',
      '',
      '',
      ' ██████   █████ █████ ███████████ ███████████      ███████    █████   █████ █████ ██████   ██████',
      '░░██████ ░░███ ░░███ ░█░░░███░░░█░░███░░░░░███   ███░░░░░███ ░░███   ░░███ ░░███ ░░██████ ██████ ',
      ' ░███░███ ░███  ░███ ░   ░███  ░  ░███    ░███  ███     ░░███ ░███    ░███  ░███  ░███░█████░███ ',
      ' ░███░░███░███  ░███     ░███     ░██████████  ░███      ░███ ░███    ░███  ░███  ░███░░███ ░███ ',
      ' ░███ ░░██████  ░███     ░███     ░███░░░░░███ ░███      ░███ ░░███   ███   ░███  ░███ ░░░  ░███ ',
      ' ░███  ░░█████  ░███     ░███     ░███    ░███ ░░███     ███   ░░░█████░    ░███  ░███      ░███ ',
      ' █████  ░░█████ █████    █████    █████   █████ ░░░███████░      ░░███      █████ █████     █████',
      '░░░░░    ░░░░░ ░░░░░    ░░░░░    ░░░░░   ░░░░░    ░░░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░ ',
      '                                                                                                 ',
      '',
      'Turn Coding into Nitro Mode',
      '',
      '',
    },
    center = {
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'New File',
        desc_hl = 'DashboardCenter',
        key = 'n',
        keymap = 'SPC n f',
        key_hl = 'DashboardCenter',
        action = 'enew',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Recent Files',
        desc_hl = 'DashboardCenter',
        key = 'r',
        key_hl = 'DashboardCenter',
        action = 'Telescope oldfiles',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Find File',
        desc_hl = 'DashboardCenter',
        key = 'f',
        keymap = 'SPC ff',
        key_hl = 'DashboardCenter',
        action = 'Telescope find_files',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Projects',
        desc_hl = 'DashboardCenter',
        key = 'p',
        keymap = 'SPC p',
        key_hl = 'DashboardCenter',
        action = 'Telescope projects',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Restore Last Session',
        desc_hl = 'DashboardCenter',
        key = 'l',
        keymap = 'SPC l',
        key_hl = 'DashboardCenter',
        action = function()
          require("auto-session").RestoreSession()
        end,
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'File Browser',
        desc_hl = 'DashboardCenter',
        key = 'b',
        keymap = 'SPC e',
        key_hl = 'DashboardCenter',
        action = 'NvimTreeToggle',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Settings',
        desc_hl = 'DashboardCenter',
        key = 's',
        key_hl = 'DashboardCenter',
        action = 'edit ' .. vim.fn.stdpath('config') .. '/init.lua',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Update Plugins',
        desc_hl = 'DashboardCenter',
        key = 'u',
        key_hl = 'DashboardCenter',
        action = 'Lazy update',
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Update NitroVim',
        desc_hl = 'DashboardCenter',
        key = 'U',
        key_hl = 'DashboardCenter',
        action = function()
          local config_path = vim.fn.stdpath("config")
          vim.cmd("echo 'Updating NitroVim...'")

          local output = {}

          vim.fn.jobstart({ "git", "-C", config_path, "pull" }, {
            stdout_buffered = true,
            on_stdout = function(_, data)
              if data then
                for _, line in ipairs(data) do
                  if line ~= "" then
                    table.insert(output, line)
                  end
                end
              end
            end,
            on_exit = function()
              local all_output = table.concat(output, "\n")
              if all_output:match("Already up to date") then
                vim.notify("NitroVim is already up to date.", vim.log.levels.INFO)
              else
                vim.notify("NitroVim update complete! Restart Neovim.", vim.log.levels.INFO)
              end
            end,
          })
        end,
      },
      {
        icon = '  ',
        icon_hl = 'DashboardCenter',
        desc = 'Quit',
        desc_hl = 'DashboardCenter',
        key = 'q',
        key_hl = 'DashboardCenter',
        action = 'qa',
      },
    },
    footer = {
      "",
      "💻 github.com/NitroVim  |   📦 @NitroBrain",
      "",
      "⚡ Fast. Minimal. Lua.  |  🚀 Crafted for Speed",
      "",
      random_quote,
      "",
    },
  },
})
