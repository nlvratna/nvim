return {
  'rose-pine/neovim',
  priority = 1000,
  name = 'rose-pine',
  config = function()
    require('rose-pine').setup {
      variant = 'main', -- auto, main, moon, or dawn
      dark_variant = 'main', -- main, moon, or dawn
      styles = {
        italic = false,
      },
    }
    vim.cmd 'colorscheme rose-pine'
  end,
}
