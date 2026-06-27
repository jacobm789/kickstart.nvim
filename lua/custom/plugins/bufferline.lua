vim.pack.add {
  'https://github.com/akinsho/bufferline.nvim',
}

require('bufferline').setup {
  options = {
    mode = 'buffers',
    numbers = 'ordinal', -- shows 1, 2, 3...
    -- or "both" / "buffer_id" / function
    -- diagnostics = 'nvim_lsp',
    -- separator_style = 'slant',
    show_buffer_close_icons = false,
    always_show_bufferline = false,
  },
}

vim.keymap.set('n', '<leader>b', function()
  local input = vim.fn.input 'Buffer number: '
  local num = tonumber(input)
  if num then require('bufferline').go_to(num, true) end
end, { desc = 'Go to [B]uffer by number' })

vim.keymap.set('n', '<A-.>', '<Cmd>BufferLineMoveNext<CR>', { silent = true }) -- Alt + . / Alt + >
vim.keymap.set('n', '<A-,>', '<Cmd>BufferLineMovePrev<CR>', { silent = true }) -- Alt + , / Alt + <
