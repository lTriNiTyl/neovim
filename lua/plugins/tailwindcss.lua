return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
        mode = "virtualtext",
        virtualtext = "  ",
      },
    },
  },
  --[[ {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    config = function(_, opts)
      opts.formatting = {
        format = function(entry, vim_item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
        end
      }
    end,
  }, ]]
}
