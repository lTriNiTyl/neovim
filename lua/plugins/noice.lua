return {
  {
    'folke/noice.nvim',
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      return opts
    end,
  }
}
