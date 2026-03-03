local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Themes
  { "navarasu/onedark.nvim" },
  { "folke/tokyonight.nvim" },
  { "tanvirtin/monokai.nvim" },
  { "folke/tokyonight.nvim" },
  { "tanvirtin/monokai.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim",         name = "catppuccin" },
  { "Mofiqul/dracula.nvim" },
  { "shaunsingh/nord.nvim" },
  { "sainnhe/everforest" },
  { "rose-pine/neovim",        name = "rose-pine" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
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
    dependencies = { "nvim-lua/plenary.nvim" },
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
    "mason-org/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "b0o/schemastore.nvim",
  },
  {
    "mason-org/mason.nvim",
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
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- CSS utilities
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
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

  -- Smear Cursor
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },

  -- Vim Surround
  {
    "tpope/vim-surround"
  },
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
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },

  -- C#
  { "OrangeT/vim-csharp" },
  { "hrsh7th/vim-vsnip" },
  {
    "seblyng/roslyn.nvim",
    opts = {},
  },

  -- Draw ASCII diagrams
  {
    "jbyuki/venn.nvim",
    config = function()
      function _G.Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd [[setlocal ve=all]]
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
          vim.cmd [[setlocal ve=]]
          vim.api.nvim_buf_del_keymap(0, "n", "J")
          vim.api.nvim_buf_del_keymap(0, "n", "K")
          vim.api.nvim_buf_del_keymap(0, "n", "L")
          vim.api.nvim_buf_del_keymap(0, "n", "H")
          vim.api.nvim_buf_del_keymap(0, "v", "f")
          vim.b.venn_enabled = nil
        end
      end

      vim.api.nvim_set_keymap("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true, silent = true })
    end
  },

  -- Project
  {
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
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
    lazy = false,
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

  { "simrat39/rust-tools.nvim" },

  -- NeoScroll
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end
  },

  -- Neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
      "nvim-neotest/nvim-nio",
      "haydenmeade/neotest-jest",
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-dotnet")({
            dap = { justMyCode = false },
          }),

          require("neotest-jest")({
            jestCommand = "npm run test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
        },

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

      vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
        { desc = "Run all tests in file" })
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle summary" })
      vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
        { desc = "Open test output" })
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
    lazy = false,
  },

  -- R
  {
    "R-nvim/R.nvim",
    lazy = false,
    config = function()
      require("r").setup()
    end,
    ft = { "r", "rmd", "quarto" },
  }
})
