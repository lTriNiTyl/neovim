return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-macchiato"
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
--    config = function()
--      vim.cmd[[colorscheme tokyonight-storm]]
--    end
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
--    config = function()
--      require('onedark').setup({
--        style = 'deep'
--      })
--      require('onedark').load()
--    end
  },
  {
    "rose-pine/neovim",
    lazy = false,
    name = "rose-pine",
    priority = 1000,
    config = function()
--      require('rose-pine').setup({
--        variant = "moon"
--      })
--      vim.cmd [[colorscheme rose-pine]]
    end
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
--    config = function()
--      vim.cmd [[colorscheme Duskfox]]
--    end
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
--    config = function()
--      vim.cmd [[colorscheme kanagawa]]
--    end
  },
}
