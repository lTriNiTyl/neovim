return {
  "nvim-neo-tree/neo-tree.nvim",
  event = 'VimEnter',
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
    require("neo-tree").setup({
      enable_git_status = true,
      enable_diagnostics = true,
      use_libuv_file_watcher = true,
      close_if_last_window = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols"
      },
      buffers = {
        follow_current_file = {
          enable = true,
        },
      },
      symbols = {
        follow_cursor = true,
      },
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
