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
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
