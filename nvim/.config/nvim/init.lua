-- Tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Line Breaks
vim.opt.colorcolumn = "80"

-- Visible whitespace
vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "»-" }

-- Highlighted Yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Visual',
      timeout = 200,
    })
  end,
})

----- Keymaps -----------------------------------------------------------------

-- Press <Esc> to clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keep selection after indentation
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
