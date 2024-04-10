return {
  "nvim-neo-tree/neo-tree.nvim",
  event = 'Bufwipeout',
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
    require("neo-tree").setup({
      use_libuv_file_watcher = true,
      close_if_last_window = true,
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
    })
  end
}
