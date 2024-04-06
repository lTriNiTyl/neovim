-- show user name
local name = function()
  local os = require("os")
  local username = os.getenv("USERNAME")
  if not username then
    username = os.getenv("USER")
  end
  return username
end

local default_sep_icons = {
  default = { left = "", right = " " },
  round = { left = "", right = "" },
  block = { left = "█", right = " " },
  -- arrow = { left = "", right = "" },
}

local folderName = function()
  local sname = vim.fn.expand("%:.")
  local kname = sname:match("([^/]+)/[^/]+$")
  local c = {}
  table.insert(c, kname)
  return table.concat(c, '/')
end

-- 현재 파일 경로 알아오고, 상위폴더만 나타내는 함수
--[[ local getScriptDirectory = function()
  local scriptPath = debug.getinfo(1, "S").source:sub(2)
  return scriptPath:match("(.*/)")
end

local cwd = function()
  local currentDir = getScriptDirectory()
  return currentDir:match(".*/([^/]+)/[^/]+/?$")
  -- return tname:match(".*/([^/]+)/?$")
end ]]

-- LSP clients attached to buffer
local clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return '\u{f085}  LSP ~ ' .. table.concat(c, '|')
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "WhoIsSethDaniel/lualine-lsp-progress.nvim",
  },
  config = function()
    require('lualine').setup({
      options = {
        -- section_separators = { left = '', right = '' },
        component_separators = '',
        icons_enabled = true,
        theme = 'auto',
        always_divide_middle = true,
        globalstatus = false,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icons_enabled = true,
            icon = '',
            separator = default_sep_icons.block,
          }
        },
        lualine_b = {
          {
            'filetype',
            colored = true,
            icon_only = true,
          },
          {
            'filename',
            file_status = true,
            newfile_status = false,
            path = 0,
            padding = 0,
            separator = default_sep_icons.block,
          }
        },
        lualine_c = {
          { 'branch', icon = { '', align = 'left', --[[color = { fg = 'white' }]] } },
          {
            'diff',
            colored = true,
            diff_color = {
              added = 'LuaLineDiffAdd',
              modified = 'LuaLineDiffChange',
              removed = 'LuaLineDiffDelete',
            },
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' '
            },
          },
        },
        lualine_x = {
          {
            'diagnostics',
            colored = true,
            sources = {
              'nvim_diagnostic',
            },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' '
            },
          },
          {
            clients_lsp,
            colored = true,
          },
        },
        lualine_y = {
          {
            folderName,
            icon = { "󰉋 ", align = 'center', color = { fg = 'black', bg = '#E06C75' } },
            color = { fg = '', bg = '' }, -- #E06C75 #99C379
            separator = { left = '' },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_z = {
          {
            'progress',
            icon = { "󰦪 ", align = 'center', color = { fg = 'black', bg = '#99C379' } },
            color = { fg = '#99C379', bg = '' }, -- #E06C75 #99C379
            separator = { left = '' },
            padding = { left = 0, right = 1 },
          }
        },
      },
    })
  end
}
