return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    { "rafamadriz/friendly-snippets" },

    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },

  opts = {
    keymap = {
      preset = "default",
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    -- signature = { enabled = true },
    completion = {
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      ghost_text = {
        enabled = false,
        show_with_selection = false,
        show_without_menu = false,
      },
      documentation = {
        auto_show = true,
        treesitter_highlighting = true,
      },

      menu = {
        -- border = "rounded",
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
          treesitter = { "lsp" },
        },
      },
    },

    cmdline = {
      enabled = true,
      -- keymap = {
      -- 	["<Tab>"] = { "show", "accept" },
      -- },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          opts = {
            search_paths = { "~/.config/nvim/lua/leela/core/snippets/vscode" },
          },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
