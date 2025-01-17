-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('grayzen').setup()

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Light theme
  -- {
  --   'rmehri01/onenord.nvim',
  --   priority = 100,
  -- },

  -- Git related plugins
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-telescope/telescope.nvim', -- optional
      {
        'sindrets/diffview.nvim',
        config = function()
          -- state. if non nil then git history traversal is using, so need to set the line
          local target_line = nil

          require('diffview').setup {
            hooks = {
              diff_buf_read = function(_, ctx)
                if target_line and ctx.symbol == 'b' then
                  vim.defer_fn(function()
                    vim.api.nvim_command(':' .. target_line)
                    target_line = nil
                  end, 100)
                end
              end,
            },
            file_panel = {
              win_config = {
                width = 50,
              },
            },
            view = {
              merge_tool = {
                layout = 'diff3_mixed',
              },
            },
          }
          vim.keymap.set('n', '<leader>gg', ':$tabnew <bar> tabclose <bar> Neogit<CR>', { silent = true, desc = 'Open Neogit' })
          vim.keymap.set('n', '<leader>gd', ':$tabnew <bar> tabclose <bar> DiffviewOpen<CR>', { silent = true, desc = 'Open Diffview' })
          vim.keymap.set('n', '<leader>gl', function()
            local current_file_line = vim.fn.line '.'
            local current_file_path = vim.fn.expand '%:.'
            local current_file_rev = nil

            -- if in diff view, then extract commit hash from path
            if vim.fn.match(current_file_path, '^diffview://') == 0 then
              local git_path = vim.fn.split(current_file_path, '.git/')[2]
              if not git_path then
                return
              end

              local list = vim.fn.matchlist(git_path, '\\(\\w\\+\\)/\\(.*\\)')
              current_file_path = list[3]
              current_file_rev = list[2]

              -- close current diff view to open a new one
              vim.api.nvim_command 'tabclose'
            end

            local blame_params = {
              'git',
              'blame',
              '-p',
              '-L' .. current_file_line .. ',' .. current_file_line,
              current_file_path,
            }
            if current_file_rev then
              blame_params[#blame_params + 1] = current_file_rev
            end
            local p_line_blame = vim.fn.system(blame_params)
            local blame = vim.fn.split(p_line_blame, '\\n')
            local blame_rev = vim.fn.split(blame[1])[1]
            local blame_line = vim.fn.split(blame[1])[2]

            local blame_filename
            for _, v in ipairs(blame) do
              local split = vim.fn.split(v)
              if split[1] == 'filename' then
                blame_filename = split[2]
                break
              end
            end

            if blame_rev == '0000000000000000000000000000000000000000' then
              vim.print 'commit not found'
            else
              target_line = blame_line
              vim.api.nvim_command '$tabnew'
              vim.api.nvim_command 'tabclose'
              vim.api.nvim_command('DiffviewOpen ' .. '--selected-file=' .. blame_filename .. ' ' .. blame_rev .. '^!')
              vim.api.nvim_command 'DiffviewToggleFiles'
            end
          end, { desc = 'Open line commit' })
          vim.keymap.set(
            'n',
            '<leader>gf',
            ':$tabnew <bar> tabclose <bar> DiffviewFileHistory % --no-merges --follow<CR>',
            { silent = true, desc = 'Open File History' }
          )
        end,
      },
    },
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '▐' },
          change = { text = '▐' },
          delete = { text = '▐' },
          topdelete = { text = '▐' },
          changedelete = { text = '▐' },
          untracked = { text = '▐' },
        },
        max_file_length = 50000,

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to prev hunk' })

          -- Actions
          map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('v', '<leader>gs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'Stage hunk' })
          map('v', '<leader>gr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'Reset hunk' })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo hunk stage' })
          map('n', '<leader>gp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
          map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'Toggle blame' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        current_line_blame_opts = {
          delay = 200,
        },
        current_line_blame_formatter = '<author_time:%R>, <author> - <summary>',
        preview_config = {
          border = 'rounded',
        },
      }
    end,
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
      },
    },
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  {
    'Wansmer/treesj',
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>m', ':TSJToggle<CR>')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        multiline_threshold = 1,
        on_attach = function(bufnr)
          vim.keymap.set('n', '[p', require('treesitter-context').go_to_context, { buffer = bufnr, silent = true })
          return true
        end,
      }
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'nvim-zh/auto-save.nvim',
    opts = {
      debounce_delay = 0,
      trigger_events = { 'BufLeave' },
    },
  },
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
      vim.g.undotree_SplitWidth = 50
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  'tpope/vim-obsession',
  'tpope/vim-repeat',
  { 'ggandor/flit.nvim', config = true },
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Linting
  {
    'mfussenegger/nvim-lint',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' }, -- to disable, comment this out
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters_by_ft = {
          javascript = { 'prettierd' },
          typescript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          graphql = { 'prettierd' },
          lua = { 'stylua' },
          scss = { 'prettierd' },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      }
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  'windwp/nvim-ts-autotag',

  -- to change tag use cst<a , to wrap area with () use ysiw(
  'tpope/vim-surround',

  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require('nvim-tmux-navigation').setup {
        keybindings = {
          left = '<C-h>',
          down = '<C-j>',
          up = '<C-k>',
          right = '<C-l>',
          last_active = '<C-\\>',
        },
      }
    end,
  },

  {
    'Asheq/close-buffers.vim',
    config = function()
      vim.keymap.set('n', '<leader>bd', ':Bdelete menu<CR>', { desc = 'Bdelete menu lets select which buffers to delete', silent = true })
    end,
  },

  'tpope/vim-unimpaired',

  {
    'RRethy/vim-illuminate',
    config = function()
      local illuminate = require 'illuminate'
      illuminate.configure { delay = 0 }

      local illuminate_enabled_buffers = {}

      local function delete_key_binding(buf)
        vim.keymap.del('n', 'n', { buffer = buf })
        vim.keymap.del('n', 'N', { buffer = buf })
      end

      local illuminate_group = vim.api.nvim_create_augroup('IlluminateBuffers', { clear = true })
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function(ev)
          if illuminate_enabled_buffers[ev.buf] == nil then
            illuminate.pause_buf()
          end
        end,
        group = illuminate_group,
      })
      vim.api.nvim_create_autocmd('BufDelete', {
        callback = function(ev)
          if illuminate_enabled_buffers[ev.buf] ~= nil then
            delete_key_binding(ev.buf)
            illuminate_enabled_buffers[ev.buf] = nil
          end
        end,
        group = illuminate_group,
      })

      vim.keymap.set('n', '<leader>i', function()
        local buf = vim.fn.bufnr()

        if illuminate_enabled_buffers[buf] == nil then
          illuminate_enabled_buffers[buf] = true
          illuminate.resume_buf()
          illuminate.freeze_buf()

          vim.keymap.set('n', 'n', function()
            illuminate.goto_next_reference()
            illuminate.freeze_buf()
          end, { desc = 'Next illuminate', silent = true, buffer = buf })
          vim.keymap.set('n', 'N', function()
            illuminate.goto_prev_reference()
            illuminate.freeze_buf()
          end, { desc = 'Prev illuminate', silent = true, buffer = buf })
        else
          illuminate_enabled_buffers[buf] = nil
          illuminate.unfreeze_buf()
          illuminate.pause_buf()
          delete_key_binding(buf)
        end
      end, { desc = 'Toggle illuminate', silent = true })

      local theme_colors = require 'grayzen.colors'
      for _, name in ipairs { 'IlluminatedWordText', 'IlluminatedWordRead', 'IlluminatedWordWrite' } do
        vim.api.nvim_set_hl(0, name, { fg = theme_colors.fg, bg = theme_colors.highlight })
      end
    end,
  },
}, {})

-- [[ LSP ]]

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup neovim lua configuration
require('neodev').setup()

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It jets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set({ 'n', 'v' }, keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>sn', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>sa', vim.lsp.buf.code_action, 'Code Action')

  nmap('<leader>sd', vim.lsp.buf.definition, 'Goto Definition')
  nmap('<leader>sr', function()
    require('telescope.builtin').lsp_references {
      show_line = false,
    }
  end, 'Goto References')
  nmap('<leader>si', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  nmap('<leader>sD', vim.lsp.buf.type_definition, 'Type Definition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>sk', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

local server_configs = {
  tsserver = {},
  graphql = {
    filetypes = { 'graphql' },
  },
  html = {
    init_options = {
      provideFormatter = false,
    },
  },
  cssls = {
    root_dir = require('lspconfig.util').root_pattern '.git' or function()
      return vim.fn.getcwd()
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(server_configs),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local config = server_configs[server_name] or {}
    config.capabilities = capabilities
    config.on_attach = on_attach
    require('lspconfig')[server_name].setup(config)
  end,
}

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.diagnostic.config {
  float = { border = 'rounded', max_width = 100 },
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message
      local MAX_LENGTH = 70
      if string.len(message) > MAX_LENGTH then
        return string.sub(message, 0, MAX_LENGTH) .. '…'
      end
      return message
    end,
  },
}
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

-- [[ LSP end ]]

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete {}
      end
    end, { 'i', 's' }),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },
}

-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', max_item_count = 5 },
  },
})

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' },
--   }, {
--     { name = 'cmdline' },
--   })
-- })

-- [[ end cmp ]]

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true
vim.o.wrapscan = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.wrap = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.swapfile = false

vim.o.scrolloff = 20
vim.o.sidescrolloff = 20

vim.o.spelllang = 'en_us'
vim.o.spell = true
-- vim.o.spellcapcheck = false
vim.o.spelloptions = 'camel'

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.opt.splitright = true -- Prefer windows splitting to the right
vim.opt.splitbelow = true -- Prefer windows splitting to the bottom

vim.o.showmode = false
vim.o.cursorline = true

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<C-w>v', ':rightbelow vsplit<CR>', { silent = true })
vim.keymap.set('n', '<C-w>V', ':rightbelow split<CR>', { silent = true })
vim.keymap.set('n', '<C-w>n', ':vnew<CR>', { silent = true })

vim.keymap.set('n', '<leader>1', ':tabn 1<CR>', { silent = true })
vim.keymap.set('n', '<leader>2', ':tabn 2<CR>', { silent = true })
vim.keymap.set('n', '<leader>3', ':tabn 3<CR>', { silent = true })
vim.keymap.set('n', '<leader>4', ':tabn 4<CR>', { silent = true })
vim.keymap.set('n', '<leader>5', ':tabn 5<CR>', { silent = true })
vim.keymap.set('n', '<leader>9', ':tablast<CR>', { silent = true })

vim.keymap.set({ 'n', 'x' }, 'gl', '$', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'gh', '^', { silent = true })

-- Do not override yank register when c or x
-- "_ is blackhole register
vim.keymap.set('n', 'c', '"_c', { silent = true })
vim.keymap.set('n', 'C', '"_C', { silent = true })
vim.keymap.set('n', 'x', '"_x', { silent = true })
vim.keymap.set('n', 'X', '"_X', { silent = true })
-- Yank pasted text after paste in visual mode, so paste will not override yank
vim.keymap.set('x', 'p', 'pgvygv<ESC>', { silent = true })

vim.keymap.set('n', '<M-S-l>', ':vertical resize +5<CR>', { silent = true })
vim.keymap.set('n', '<M-S-h>', ':vertical resize -5<CR>', { silent = true })
vim.keymap.set('n', '<M-S-k>', ':horizontal resize +5<CR>', { silent = true })
vim.keymap.set('n', '<M-S-j>', ':horizontal resize -5<CR>', { silent = true })

-- vim.keymap.set('n', '<leader>ee', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>', { silent = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlighting after search
vim.keymap.set('n', '<leader>h', function()
  if vim.v.hlsearch == 0 then
    vim.o.hlsearch = true
  else
    -- can not use vim.v.hlsearch = false, because next search will not be highlighted
    -- :noh will disable highlight till next search
    vim.api.nvim_command ':noh'
  end
end, { desc = 'Toggle search highlighting' })

vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save buf :w' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual' }
  end,
  group = highlight_group,
  pattern = '*',
})

-- autoreload file from disk after change outside nvim
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  pattern = '*',
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      n = {
        ['<C-p>'] = require('telescope.actions').cycle_history_prev,
        ['<C-n>'] = require('telescope.actions').cycle_history_next,
      },
    },
    layout_strategy = 'vertical',
    layout_config = {
      vertical = { width = 0.8, height = 0.95 },
    },
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
          ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = " -g '**/{*}/**/*.{js,jsx,ts,tsx}' -g '!*_spec.*' -iF " },
        },
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require('telescope').load_extension 'live_grep_args'

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><Tab>', function()
  require('telescope.builtin').buffers { sort_mru = true }
end, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>fc', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fh', function()
  require('telescope.builtin').help_tags()
end, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Find current Word' })
-- vim.keymap.set('n', '<leader>fgg', require('telescope.builtin').live_grep, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Find Diagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'help',
    'vim',
    'c',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'javascript',
    'json',
    'graphql',
  },

  -- tree-sitter cli should be installed to support true
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = false, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  autotag = {
    enable = true,
  },
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup {
  view = {
    width = 50,
  },
}
require('nvim-web-devicons').setup {
  color_icons = false,
}

-- require('onenord').setup({ theme = 'light' })

-- require("auto-save").setup()

require('ibl').setup {
  indent = {
    char = '▏',
  },
  whitespace = {
    remove_blankline_trail = true,
  },
  scope = {
    enabled = false,
  },
}

require('neogit').setup {
  integrations = {
    telescope = true,
    diffview = true,
  },
  mappings = {
    status = {
      ['o'] = 'Toggle',
    },
  },
  console_timeout = 1000,
  auto_show_console = true,
  status = {
    recent_commit_count = 20,
  },
}

vim.keymap.set('n', '<leader>t', ':tabclose<CR>', { silent = true, desc = 'Close Current Tab' })

require('lualine').setup {
  options = {
    component_separators = '',
    section_separators = '',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'windows' },
    lualine_x = {
      function()
        local path_table = vim.fn.split(vim.fn.getcwd() or '', '/')
        return path_table[#path_table]
      end,
      'encoding',
      'fileformat',
    },
    lualine_y = { 'progress' },
    lualine_z = {
      function()
        local line = vim.fn.line '.'
        local total_lines = vim.fn.line '$'
        local col = vim.fn.virtcol '.'
        return string.format('%3d/%d:%-2d', line, total_lines, col)
      end,
    },
  },
  winbar = {
    lualine_x = {
      {
        'filename',
        path = 1,
      },
    },
  },
  inactive_winbar = {
    lualine_x = {
      {
        'filename',
        path = 1,
      },
    },
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 2,
        path = 0,
        show_modified_status = false,
        max_length = vim.o.columns,
        tabs_color = {
          -- Same values as the general color option can be used here.
          active = 'lualine_tabline_normal', -- Color for active tab.
          inactive = 'lualine_tabline_inactive', -- Color for inactive tab.
        },
        fmt = function(_, context)
          -- set mode to one, because lualine force it to 2
          vim.o.showtabline = 1

          local tab_name = ''
          for i, v in ipairs(vim.fn.tabpagebuflist(context.tabnr)) do
            if i > 1 then
              tab_name = tab_name .. ' '
            end
            tab_name = tab_name .. vim.fs.basename(vim.fn.bufname(v) or '')
          end
          return tab_name
        end,
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
