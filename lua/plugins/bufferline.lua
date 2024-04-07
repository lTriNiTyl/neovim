vim.g.mode = 'buffers'

local txt = function(str, hl)
  str = str or ""
  local a = "%#" .. hl .. "#" .. str
  return a
end

local btn = function(str, hl, func, args)
  str = hl and txt(str, hl) or str
  args = args or ""
  local a = "%" .. args .. "@" .. func .. "@" .. str .. "%X"
  return a
end

vim.cmd [[
function! Empty(a,b,c,d)
endfunction
]]

vim.cmd [[
function! CloseAllBufs(a, b, c, d)
lua << EOF
local buffers = vim.fn.getbufinfo({ buflisted = 1 })
for _, buffer in ipairs(buffers) do
vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
end
EOF
endfunction
]]

vim.cmd [[
function! NewTab(a, b, c, d)
tabnew
endfunction
]]

vim.cmd [[
function! CloseTab(a, b, c, d)
tabclose
endfunction
]]

vim.cmd [[
function! GoToTab(tabnr,b,c,d)
execute a:tabnr ..'tabnext'
endfunction
]]

local colors = {
  active = { fg = '#3f3f3f', bg = '#E06C75' --[[ '#89B4FA' ]] },
  default = { fg = 'white', bg = '#3f3f3f' },
  tab_label = { fg = '#3f3f3f', bg = 'LightYellow' },
  buffer_close = { fg = 'black', bg = '#89B4FA' --[[ '#E06C75' ]] },
}

--[[ local default_sep_icons = {
  default = { left = "", right = " " },
  round = { left = "", right = "" },
  block = { left = "█", right = " " },
  arrow = { left = "", right = "" },
} ]]

-- set highlight group
vim.api.nvim_set_hl(0, 'TabNewBtn', { fg = colors.default.fg, bg = colors.default.bg })
vim.api.nvim_set_hl(0, 'TabLabel', { fg = colors.tab_label.fg, bg = colors.tab_label.bg })
vim.api.nvim_set_hl(0, 'GoToActive', { fg = colors.active.fg, bg = colors.active.bg })
vim.api.nvim_set_hl(0, 'CloseTabBtn', { fg = 'Black', bg = colors.active.bg })
vim.api.nvim_set_hl(0, 'GoToSmall', { fg = colors.default.fg, bg = colors.default.bg })
vim.api.nvim_set_hl(0, 'CloseAllBtn', { fg = colors.buffer_close.fg, bg = colors.buffer_close.bg })

-- 새로운 것들을 많이 배웠다.
-- bufferline.nvim에서 top right에 버튼을 추가해 보기로 했다. nvchad와 비슷하게.
-- custom_areas를 이용해 right를 추가할 수있다.
-- 일단, table.insert를 통해 오른쪽에 추가할 버튼들을 추가 할 수 있다.
-- text, fg, bg를 통해 text에 icon을 넣으면 나타나긴 한다.
-- 2번째 문제 : click 할 수 있게 하고 싶은데, 방법을 찾지 못했다.
-- 그러다, bufferline closed된 이슈를 보니 나와 같은 고민을 하는 사람의 질문을 찾을 수 있었다.
-- %@func@ x %X : 이렇게 하면 vim script func를 호출할 수 있고, %X를 함으로써 클릭이 가능하게 되고, x라는 아이콘이 표시된다.
-- 3번째 문제 : fg, bg를 통해 색상을 설정했었는데, 오류가 발생 색상들이 버튼들마다 뒤섞여서 이상하게 나온다.
-- 해결책 : %#을 이용하면 된다더라. set highlight group을 이용하는 것이다.
-- %#hl_name# 이걸 이용하는 방법인데 vim.cmd highlight hl_name guifg = gold guibg = red 뭐 이런식으로 쓴다더라.
-- 그런데 nvim_command로 해도 색상이 안입혀졌다.
-- 찾은 방법 vim.api.nvim_set_hl함수를 이용하면 된다.
-- 원하던 대로 완성.
return {
  {
    'akinsho/bufferline.nvim',
    after = 'catppuccin',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    require("bufferline").setup {
      options = {
        custom_areas = {
          right = function()
            local result = {}
            local add_tab = { text = btn(' 󰐕 ', 'TabNewBtn', 'NewTab') }
            table.insert(result, add_tab)
            if (#vim.api.nvim_list_tabpages() > 1) then
              local tab_label = { text = btn(' TABS ', 'TabLabel', 'Empty') }
              table.insert(result, tab_label)
              for i = 1, #vim.api.nvim_list_tabpages() do
                if i == vim.fn.tabpagenr() then
                  local active_tabs_entry = {
                    text = btn(" " .. i .. '%@CloseTab@ %#CloseTabBtn# %X', 'GoToActive',
                      'GoToTab', i)
                  }
                  table.insert(result, active_tabs_entry)
                else
                  local inactive_tabs_entry = { text = btn(" " .. i .. " ", 'GoToSmall', 'GoToTab', i) }
                  table.insert(result, inactive_tabs_entry)
                end
              end
            end
            local close_buffer = { text = btn(' 󰅖 ', 'CloseAllBtn', 'CloseAllBufs') }
            table.insert(result, close_buffer)
            return result
          end
        },
        mode = vim.g.mode,
        numbers = "none",                    -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
        -- NOTE: this plugin is designed with this icon in mind,
        -- and so changing this is NOT recommended, this is intended
        -- as an escape hatch for people who cannot bear it for whatever reason
        indicator_icon = nil,
        indicator = { style = "none", icon = " " },
        buffer_close_icon = '󰅖',
        modified_icon = "●",
        close_icon = "󰅖", --"",
        close_tab_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        move_wraps_at_ends = true,
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
        --   -- remove extension from markdown files for example
        --   if buf.name:match('%.md') then
        --     return vim.fn.fnamemodify(buf.name, ':t:r')
        --   end
        -- end,
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = false,    -- | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   return "("..count..")"
        -- end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        -- custom_filter = function(buf_number)
        --   -- filter out filetypes you don't want to see
        --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        --     return true
        --   end
        --   -- filter out by buffer name
        --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        --     return true
        --   end
        --   -- filter out based on arbitrary rules
        --   -- e.g. filter out vim wiki buffer from tabline in your work repo
        --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        --     return true
        --   end
        -- end,
        offsets = { { filetype = "neo-tree", text = "", padding = 1 } },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = { '|', '|' }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        --   -- add custom logic
        --   return buffer_a.modified > buffer_b.modified
        -- end
      },
      -- highlights = require("catppuccin.groups.integrations.bufferline").get()
    }
  },
}
