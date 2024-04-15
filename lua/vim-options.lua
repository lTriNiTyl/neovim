local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tab & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start"

-- turn off swapfile
opt.swapfile = false

-- cursor line
opt.cursorline = true

opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- bufferline 관련 [[
vim.g.mode = 'buffers'
vim.g.bToggled = 0

ToggleNeotreeAndSetToggled = function()
  vim.cmd(':Neotree filesystem reveal left toggle')
  vim.g.bToggled = vim.g.bToggled == 0 and 1 or 0
  vim.cmd 'redrawtabline'
end

local opts = { noremap = true, silent = true  }
vim.keymap.set('n', '<leader>nt', ':lua ToggleNeotreeAndSetToggled()<CR>', opts)
-- ]]

-- Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

--[[ vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
vim.keymap.set("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" })                          --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab ]]
vim.keymap.set('n', '<tab>', '<Cmd>BufferLineCycleNext<CR>', {desc = 'Next buffer'})
vim.keymap.set('n', '<S-tab>', '<Cmd>BufferLineCyclePrev<CR>', {desc = 'Previous buffer'})
