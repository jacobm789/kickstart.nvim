vim.o.signcolumn = 'auto:5'

vim.o.scrolloff = 5

vim.o.relativenumber = true

vim.opt.wrap = true

vim.opt.breakat = ' ^I!@*-+;:,/?'
vim.opt.linebreak = true
vim.opt.showbreak = '↪'

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4

vim.diagnostic.config {
  virtual_text = false,
}

require('which-key').setup {
  { '<leader>tt', group = '[T]rim' },
}

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

---@type table<string, vim.lsp.Config>
local servers = {
  clangd = {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--limit-results=0',
      '--compile-commands-dir=build',
    },
  },
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},

  stylua = {}, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}

-- Automatically install LSPs and related tools to stdpath for Neovim
require('mason').setup {}

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  -- You can add other tools here that you want Mason to install
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

local parsers = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(parsers)

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

-- require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.indent_line'
-- require 'kickstart.plugins.lint'
-- require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.neo-tree'
require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

require 'custom.plugins'
