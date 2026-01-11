return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "main", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        styles = {
          italic = false,
        },
        palette = {
          main = {
            base = "none",
          },
        },
        highlight_groups = {
          TelescopeNormal = { bg = "base" },
          TelescopeResultsNormal = { bg = "base" },
          TelescopePromptsNormal = { bg = "base" },
          TelescopeBorder = { bg = "base" },
          -- BlinkCmpDoc = { bg = "highlight_low" },
        },
      })
      -- vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
        on_colors = function(c)
          c.bg = "none"
        end,
        on_highlights = function(hl, c)
          hl.TelescopeNormal = { bg = c.bg }
          hl.TelescopeBorder = { bg = c.bg }
          hl.TelescopePromptBorder = { bg = c.bg }
        end,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
