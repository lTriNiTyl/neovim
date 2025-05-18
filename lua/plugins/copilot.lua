return {
  {
    --"github/copilot.vim",
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    -- event = 'BufEnter',
    config = function()
      require('codeium').setup({})
    end
  },
  {
    'AndreM222/copilot-lualine',
    show_colors = true,
  },
}
