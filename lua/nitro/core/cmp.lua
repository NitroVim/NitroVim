local function has_plugin(name)
  local ok, _ = pcall(require, name)
  return ok
end

local function setup_completion()
  local cmp = require("cmp")
  local luasnip = has_plugin("luasnip") and require("luasnip") or nil

  if has_plugin("luasnip.loaders.from_vscode") then
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" }
    })
  end

  local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        if luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },

    window = {
      completion = cmp.config.window.bordered({
        border = "rounded",
        winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None",
      }),
      documentation = cmp.config.window.bordered({
        border = "rounded",
        max_width = 60,
        max_height = 15,
        winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None",
      }),
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local source_info = {
          nvim_lsp = "LSP",
          luasnip = "Snippet",
          buffer = "Buffer",
          path = "Path",
          cmdline = "Cmd",
        }

        vim_item.kind = string.format("%s ", kind_icons[vim_item.kind] or "󰈚")
        return vim_item
      end,
    },

    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 900 },
      { name = "luasnip", priority = 800 },
      { name = "buffer", priority = 700 },
      { name = "path", priority = 600 },
    }),

    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },

    experimental = {
      ghost_text = true,
    },
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

setup_completion()

return {
  setup = setup_completion,
}