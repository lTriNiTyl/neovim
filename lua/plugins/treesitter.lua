return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function ()
      require('nvim-ts-autotag').setup({
        autotag = { enable = true },
      })
    end,
    lazy = true,
    event = "VeryLazy"
  }
}
