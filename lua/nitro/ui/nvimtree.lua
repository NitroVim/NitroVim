local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("nvim-tree not found!", vim.log.levels.ERROR)
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

pcall(require, "nvim-web-devicons")

local api = require("nvim-tree.api")

local function save_position(position)
  local file = io.open(vim.fn.expand("~/.nvim-tree-position"), "w")
  if file then
    file:write(position)
    file:close()
  end
end

local function read_position()
  local file = io.open(vim.fn.expand("~/.nvim-tree-position"), "r")
  if file then
    local position = file:read("*l")
    file:close()
    if position == "left" or position == "right" or position == "center" then
      return position
    end
  end
  return "center"
end

local saved_position = read_position()

nvim_tree.setup({
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,

  view = {
    width = 35,
    side = saved_position == "right" and "right" or "left",
    cursorline = true,
    signcolumn = "yes",
    float = {
      enable = saved_position == "center",
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get()
        local win_w = math.floor(screen_w * 0.4)
        local win_h = math.floor(screen_h * 0.8)
        local win_w_int = math.floor((screen_w - win_w) / 2)
        local win_h_int = math.floor((screen_h - win_h) / 2)
        return {
          border = "rounded",
          relative = "editor",
          row = win_h_int,
          col = win_w_int,
          width = win_w,
          height = win_h,
        }
      end,
    },
  },

  renderer = {
    indent_width = 2,
    highlight_git = true,
    highlight_opened_files = "none",
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
    },
    icons = {
      webdev_colors = true,
      git_placement = "after",
      show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
      glyphs = {
        default = "",
        symlink = "",
        modified = "●",
        folder = {
          default = "",
          open = "",
          arrow_open = "",
          arrow_closed = "",
          empty = "",
          empty_open = "",
        },
        git = {
          unstaged = "",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    root_folder_label = function(path)
      return "󱉟 " .. vim.fn.fnamemodify(path, ":t")
    end,
    special_files = { "README.md", "Makefile", "Cargo.toml", "package.json" },
  },

  hijack_directories = { enable = true, auto_open = true },

  update_focused_file = { enable = true },

  filters = { dotfiles = false },

  filesystem_watchers = { enable = false },

  git = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true, timeout = 400 },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    icons = { hint = "󰌵", info = "󰋼", warning = "", error = "" },
  },

  actions = {
    use_system_clipboard = true,
    change_dir = { enable = true },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        picker = "default",
        chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = { close_window = false },
  },

  trash = { cmd = "trash", require_confirm = true },

  live_filter = { prefix = "╭─🔍 ", always_show_folders = true },

  notify = { threshold = vim.log.levels.INFO },
})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>', opts)
vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>', opts)
vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeFocus<CR>', opts)

vim.cmd([[
  highlight NvimTreeNormal guibg=NONE ctermbg=NONE
  highlight NvimTreeNormalNC guibg=NONE ctermbg=NONE
  highlight NvimTreeGitNew guifg=#3EEA4D
  highlight NvimTreeGitDeleted guifg=#F44747
  highlight NvimTreeGitDirty guifg=#F0A500
  highlight NvimTreeLiveFilterPrefix guifg=#FFFFFF guibg=#5E81AC gui=bold
  highlight NvimTreeLiveFilterValue guifg=#ECEFF4 guibg=#434C5E gui=bold,italic
  highlight NvimTreeLiveFilterBorder guifg=#5E81AC guibg=NONE gui=bold
]])

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      api.tree.open()
    end
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins, floating_wins = {}, {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") then table.insert(tree_wins, w) end
      if vim.api.nvim_win_get_config(w).relative ~= "" then table.insert(floating_wins, w) end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do vim.api.nvim_win_close(w, true) end
    end
  end,
})

vim.api.nvim_create_user_command("FileExplorer", function(opts)
  local arg = opts.args:lower()

  if arg == "left" or arg == "right" or arg == "center" then
    save_position(arg)
  end

  if arg == "left" then
    require("nvim-tree").setup({
      view = {
        width = 35,
        side = "left",
        cursorline = true,
        signcolumn = "yes"
      },
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_cursor = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,

      renderer = {
        indent_width = 2,
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
        },
        icons = {
          webdev_colors = true,
          git_placement = "after",
          show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
          glyphs = {
            default = "",
            symlink = "",
            modified = "●",
            folder = {
              default = "",
              open = "",
              arrow_open = "",
              arrow_closed = "",
              empty = "",
              empty_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        root_folder_label = function(path)
          return "󱉟 " .. vim.fn.fnamemodify(path, ":t")
        end,
        special_files = { "README.md", "Makefile", "Cargo.toml", "package.json" },
      },

      hijack_directories = { enable = true, auto_open = true },

      update_focused_file = { enable = true },

      filters = { dotfiles = false },

      filesystem_watchers = { enable = false },

      git = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true, timeout = 400 },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = { hint = "󰌵", info = "󰋼", warning = "", error = "" },
      },

      actions = {
        use_system_clipboard = true,
        change_dir = { enable = true },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = { close_window = false },
      },

      trash = { cmd = "trash", require_confirm = true },

      live_filter = { prefix = "╭─🔍 ", always_show_folders = true },

      notify = { threshold = vim.log.levels.INFO },
    })
    vim.cmd("NvimTreeOpen")
  elseif arg == "right" then
    require("nvim-tree").setup({
      view = {
        width = 35,
        side = "right",
        cursorline = true,
        signcolumn = "yes",
      },
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_cursor = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,

      renderer = {
        indent_width = 2,
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
        },
        icons = {
          webdev_colors = true,
          git_placement = "after",
          show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
          glyphs = {
            default = "",
            symlink = "",
            modified = "●",
            folder = {
              default = "",
              open = "",
              arrow_open = "",
              arrow_closed = "",
              empty = "",
              empty_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        root_folder_label = function(path)
          return "󱉟 " .. vim.fn.fnamemodify(path, ":t")
        end,
        special_files = { "README.md", "Makefile", "Cargo.toml", "package.json" },
      },

      hijack_directories = { enable = true, auto_open = true },

      update_focused_file = { enable = true },

      filters = { dotfiles = false },

      filesystem_watchers = { enable = false },

      git = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true, timeout = 400 },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = { hint = "󰌵", info = "󰋼", warning = "", error = "" },
      },

      actions = {
        use_system_clipboard = true,
        change_dir = { enable = true },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = { close_window = false },
      },

      trash = { cmd = "trash", require_confirm = true },

      live_filter = { prefix = "╭─🔍 ", always_show_folders = true },

      notify = { threshold = vim.log.levels.INFO },
    })
    vim.cmd("NvimTreeOpen")
  elseif arg == "center" then
    require("nvim-tree").setup({
      view = {
        side = "left",
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get()
            local win_w = math.floor(screen_w * 0.4)
            local win_h = math.floor(screen_h * 0.8)
            return {
              border = "rounded",
              relative = "editor",
              row = (screen_h - win_h) / 2,
              col = (screen_w - win_w) / 2,
              width = win_w,
              height = win_h,
            }
          end,
        },
      },
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_cursor = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,

      renderer = {
        indent_width = 2,
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
        },
        icons = {
          webdev_colors = true,
          git_placement = "after",
          show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
          glyphs = {
            default = "",
            symlink = "",
            modified = "●",
            folder = {
              default = "",
              open = "",
              arrow_open = "",
              arrow_closed = "",
              empty = "",
              empty_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        root_folder_label = function(path)
          return "󱉟 " .. vim.fn.fnamemodify(path, ":t")
        end,
        special_files = { "README.md", "Makefile", "Cargo.toml", "package.json" },
      },

      hijack_directories = { enable = true, auto_open = true },

      update_focused_file = { enable = true },

      filters = { dotfiles = false },

      filesystem_watchers = { enable = false },

      git = { enable = true, ignore = false, show_on_dirs = true, show_on_open_dirs = true, timeout = 400 },

      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        icons = { hint = "󰌵", info = "󰋼", warning = "", error = "" },
      },

      actions = {
        use_system_clipboard = true,
        change_dir = { enable = true },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = { close_window = false },
      },

      trash = { cmd = "trash", require_confirm = true },

      live_filter = { prefix = "╭─🔍 ", always_show_folders = true },

      notify = { threshold = vim.log.levels.INFO },
    })
    vim.cmd("NvimTreeOpen")
  else
    vim.notify("Usage: :FileExplorer {left|right|center}", vim.log.levels.WARN)
  end
end, {
  nargs = 1,
  complete = function() return { "left", "right", "center" } end,
})
