--
-- ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
-- ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
-- ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
-- ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
-- ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
--
-- Morten Bojsen-Hansen <morten@alas.dk>
-- Loosely based on https://github.com/nvim-lua/kickstart.nvim

vim.o.expandtab = true -- Expand tabs to spaces.
vim.o.tabstop = 4 -- Set the number of spaces a TAB counts for.
vim.o.shiftwidth = 0 -- Use tabstop value.
vim.o.number = true -- Line numbers.
vim.o.relativenumber = true -- Relative line numbers.
vim.o.mouse = 'a' -- Enable the use of mouse clicks in all modes.
vim.o.scrolloff = 10 -- Minimum number of screen lines to keep above and below the cursor.
vim.o.cursorline = true -- Highlight line under the cursor.
vim.o.ignorecase = true -- Ignore case in searches.
vim.o.smartcase = true -- Overrides ignorecase if search pattern contains upper-case.
vim.o.backup = true -- Always keep a backup of edited files.
vim.opt.backupdir:remove(".") -- Remove current directory.
vim.o.undofile = true -- Persistent undo.
vim.o.termguicolors = true -- True color support.
vim.g.mapleader = ',' -- Set <Leader>.
vim.g.maplocalleader = ',' -- Set <LocalLeader>.
vim.o.wildmode = 'full:longest' -- When auto-completing, show navigatable list and longest common prefix.
vim.o.wrap = false -- Disable wrapping of lines.

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Add a timestamp to backup files',
  pattern = '*',
  callback = function() vim.opt.backupext = vim.fn.strftime(' @ %Y-%m-%d %H:%M:%S') end
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Disable insertion of comment leader',
  pattern = '*',
  callback = function() vim.opt.formatoptions:remove({'c','r','o'}) end
})

-- Convenience mappings.
vim.keymap.set('c', '<C-j>', '<C-n>', { noremap = true, desc = 'Move to next wildmenu item' })
vim.keymap.set('c', '<C-k>', '<C-p>', { noremap = true, desc = 'Move to previous wildmenu item' })
vim.keymap.set('n', 'gk', 'gg', { noremap = true, desc = '[G]o to start of file' })
vim.keymap.set('n', 'gj', 'G', { noremap = true, desc = '[G]o to end of file' })
vim.keymap.set('n', 'gh', '^', { noremap = true, desc = '[G]o to start of line' })
vim.keymap.set('n', 'gl', '$', { noremap = true, desc = '[G]o to end of line' })
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('x', '<Leader>p', '\"_dP', { desc = 'Paste without overwriting the default register' })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = e.buf, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, { buffer = e.buf, desc = '[G]oto [D]eclaration' })
        -- See `:help K` for why this keymap
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = e.buf, desc = 'Hover Documentation' })
        vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, { buffer = e.buf, desc = 'Signature [H]elp' })
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { buffer = e.buf, desc = '[D]iagnostic previous' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { buffer = e.buf, desc = '[D]iagnostic next' })
    end
})

-- Bootstrap package manager.
do
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
      })
    end
    vim.opt.runtimepath:prepend(lazypath)
end

require("lazy").setup {
    -- Language Server Protocol.
    { 'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup {
                ensure_installed = { "clangd", "pyright" }
            }
            require("mason-lspconfig").setup_handlers {
                function(server) require('lspconfig')[server].setup {} end
            }
        end
    },

    -- Tree sitter support.
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'c', 'cpp', 'python', 'vimdoc' },
                highlight = { enable = true, },
            }
        end
    },

    -- Auto-completion.
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup {
                snippet = {
                    expand = function(args)
                        snip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-k>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmdline' },
                },
            }
        end
    },

    -- Theme
    {
        'Mofiqul/dracula.nvim',
        config = function() vim.cmd('colorscheme dracula') end
    },

    -- Fancier statusline.
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'onedark',
                    component_separators = '|',
                    section_separators = '',
                },
            }
        end
    },

    -- Telescope is a highly extensible fuzzy finder for Neovim.
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local actions = require('telescope.actions')

            require('telescope').setup {
                defaults = {
                    mappings = {
                        -- Move between selections using the home row.
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                        },
                    },
                },
            }

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<Leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<Leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
            vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<Leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<Leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<Leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        end
    },

    -- Use fzf as sorter in Telescope. It's faster and supports fzf patterns such as 'exact matches.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function() require('telescope').load_extension('fzf') end
    },

    -- Use "gc" to comment visual regions/lines.
    {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    },

    -- Transparent background in Neovim. Does what it says on the tin.
    -- Enable with :TransparentEnable (cached).
    {
        'xiyaowong/nvim-transparent',
    },

    -- :Git <cmd>
    { 'tpope/vim-fugitive' },

    -- Git decorations
    -- Neovim file explorer.
    {
        'stevearc/oil.nvim',
        config = function() require('oil').setup() end,
    },

    -- Nerd fonts
    -- Run :NvimWebDeviconsHiTest to verify that it works.
    {
        'nvim-tree/nvim-web-devicons',
        config = function() require('nvim-web-devicons').setup() end
    },
}
