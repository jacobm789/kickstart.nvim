vim.o.relativenumber = true

-- Enable line wrapping
vim.opt.wrap = true

-- Break lines at word boundries
vim.opt.breakat = ' ^I!@*-+;:,/?'
vim.opt.linebreak = true
vim.opt.showbreak = '↪'

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4

-- Function to trim trailing whitespace
local function trim_trailing_whitespace()
  local save = vim.fn.winsaveview()
  vim.cmd [[keeppatterns %s/\s\+$//e]]
  vim.fn.winrestview(save)
end

vim.keymap.set({ 'n', 'v' }, '<leader>ttw', trim_trailing_whitespace, {
  desc = '[T]rim [T]railing [W]hitespace',
  silent = true,
})

vim.keymap.set('n', '<leader>ct', '<cmd>checktime<CR>', { desc = '[C]heck[T]ime' })
vim.keymap.set('n', '<leader>rl', '<cmd>lsp restart<CR>', { desc = '[R]estart [L]sp' })

vim.keymap.set(
  'n',
  '<leader>sa',
  function() require('telescope.builtin').find_files { hidden = true, no_ignore = true } end,
  { desc = '[S]earch [A]ll files (incl. ignored)' }
)

local function toggle_diagnostic_mode()
  local current = vim.g.diag_mode or 'minimal' -- default to signs-only on first run

  if current == 'minimal' then
    vim.diagnostic.config { virtual_lines = true }
    vim.g.diag_mode = 'virtual_text'
  else
    vim.diagnostic.config { virtual_lines = false }
    vim.g.diag_mode = 'minimal'
  end
end

vim.keymap.set('n', '<leader>td', toggle_diagnostic_mode, {
  desc = '[T]oggle [D]iagnostic virtual text and signs',
})

vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
