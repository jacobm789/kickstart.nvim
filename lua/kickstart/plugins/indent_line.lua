-- Add indentation guides even on blank lines

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }

require('ibl').setup {
  scope = {
    enabled = false,
  },
  indent = {
    --   char = '│', -- thin vertical line (you can also use '┊', '▏', etc.)
    --   tab_char = '|', -- only needed if you mix tabs + spaces
  },
}
