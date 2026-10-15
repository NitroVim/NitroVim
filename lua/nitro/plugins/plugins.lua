local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local dap_config = require("nitro.core.dap")

require("lazy").setup({

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeRefresh", "FileExplorer" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>",   desc = "Toggle File Explorer" },
      { "<leader>h", "<cmd>NvimTreeFocus<CR>",    desc = "Focus File Explorer" },
      { "<leader>r", "<cmd>NvimTreeRefresh<CR>",  desc = "Refresh File Explorer" },
      { "<leader>n", "<cmd>NvimTreeFindFile<CR>", desc = "Find File in Explorer" },
      { "<leader>o", "<cmd>NvimTreeFocus<CR>",    desc = "Focus File Explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            require("nitro.ui.nvimtree")
          end
        end,
      })
    end,
    config = function()
      require("nitro.ui.nvimtree")
    end,
  },

  -- Themes
  { "navarasu/onedark.nvim",    lazy = true },
  { "folke/tokyonight.nvim",    lazy = true },
  { "tanvirtin/monokai.nvim",   lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "catppuccin/nvim",          name = "catppuccin", lazy = true },
  { "Mofiqul/dracula.nvim",     lazy = true },
  { "shaunsingh/nord.nvim",     lazy = true },
  { "sainnhe/everforest",       lazy = true },
  { "rose-pine/neovim",         name = "rose-pine",  lazy = true },

  -- Tabs / Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nitro.ui.dashboard")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Telescope live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Telescope buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Telescope help tags" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
    },
    config = function()
      require("nitro.core.telescope")
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local ok, toggleterm = pcall(require, "toggleterm")
      if not ok then
        vim.notify("ToggleTerm not found!", vim.log.levels.WARN)
        return
      end

      toggleterm.setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = false,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
          winblend = 5,
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true })
        end,
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
        { noremap = true, silent = true, desc = "Toggle LazyGit" })
    end,
  },

  -- LSP + Mason
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("nitro.lsp.lsp")
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    config = function()
      require('mason').setup({
        registries = {
          'github:Crashdummyy/mason-registry',
          'github:mason-org/mason-registry',
        },
      })
    end
  },

  -- Completion (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("nitro.core.cmp")
    end,
  },
  { "hrsh7th/cmp-nvim-lsp",     lazy = true },
  { "hrsh7th/cmp-buffer",       lazy = true },
  { "hrsh7th/cmp-path",         lazy = true },
  { "hrsh7th/cmp-cmdline",      lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = dap_config.setup_dap,
    keys = dap_config.keys,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = dap_config.setup_dapui,
  },
  { "nvim-neotest/nvim-nio",        lazy = true },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("nitro.snippets.snippets")
      require("nitro.snippets.custom.custom_snippets")
    end,
  },
  { "rafamadriz/friendly-snippets", lazy = true },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    config = function()
      require("nitro.core.treesitter")
    end,
  },

  -- CSS utilities
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {},
      filetypes = {
        "*",
        "!NvimTree",
        "!dashboard",
        "!alpha",
        "!lazy",
        "!TelescopePrompt",
        "!neo-tree",
      },
    },
  },

  -- Auto Save
  {
    "pocco81/auto-save.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("auto-save").setup {
        enabled = true,
        execution_message = {
          message = function() return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")) end,
          dim = 0.18,
          cleaning_interval = 1250,
        },
        trigger_events = { "InsertLeave", "TextChanged" },
        conditions = {
          exists = true,
          filename_is_not = {},
          filetype_is_not = {},
          modifiable = true,
        },
        write_all_buffers = false,
        debounce_delay = 135,
      }
    end,
  },

  -- TODO COMMENTS
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Transparent
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
      end,
    },
  },

  -- Noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "rcarriga/nvim-notify", lazy = false, },

  -- Vim Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  -- Auto Tag
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ..." },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble quickfix toggle<cr>",                           desc = "Quickfix List (Trouble)" },
    },
  },

  -- C# / Dotnet / Languages
  { "hrsh7th/vim-vsnip",   lazy = true },
  { "jlcrochet/vim-razor", ft = { "razor", "cshtml" } },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      require("easy-dotnet").setup()
    end
  },

  { "folke/snacks.nvim",        lazy = true },
  { "simrat39/rust-tools.nvim", ft = "rust" },

  -- Project (loaded with Telescope because its only integration is a Telescope extension)
  {
    "ahmedkhalf/project.nvim",
    lazy = true,
    config = function()
      require("project_nvim").setup({
        manual_mode = true,
        detection_methods = { "pattern" },
        patterns = {
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "Makefile",
          "package.json",
          "pyproject.toml",
        },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })

      require("telescope").load_extension("projects")
    end,
  },

  -- Auto Session
  {
    "rmagatti/auto-session",
    cmd = { "SessionSave", "SessionRestore", "SessionDelete" },
    config = function()
      vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds,localoptions"

      require("auto-session").setup({
        log_level = "info",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = false,
        auto_session_suppress_dirs = { "~/" },
      })
    end,
  },

  -- Text Case
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },

  -- Render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" },
    cmd = { "RenderMarkdown" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {},
  },
  { "nvim-mini/mini.nvim", lazy = true },

  -- Diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  { "onsails/lspkind.nvim", lazy = true },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    cmd = "Lspsaga",
    config = function()
      require("lspsaga").setup({
        ui = {
          winbar = {
            enabled = false,
          },
        },
        lightbulb = {
          enable = false,
        },
      })
      vim.lsp.handlers["textDocument/hover"] =
          require("lspsaga.hover").hover_handler
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Shared Dependencies
  { "nvim-lua/plenary.nvim",       lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}, {
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
