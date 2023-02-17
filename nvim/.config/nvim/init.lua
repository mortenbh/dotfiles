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
vim.o.cursorline = true -- Gighlight line currently under the cursor.
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

-- Add a timestamp to backup files.
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Add a timestamp to backup files',
  pattern = '*',
  callback = function() vim.opt.backupext = vim.fn.strftime(' @ %Y-%m-%d %H:%M:%S') end
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
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines' })
vim.keymap.set('x', '<Leader>p', '\"_dP', { desc = 'Paste without overwriting the default register' })
-- vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true, desc = '[W]rite buffer' })
-- vim.keymap.set('n', '<Leader>d', ':bd<CR>', { noremap = true, silent = true, desc = 'Buffer [d]elete' })
-- vim.keymap.set('n', '<Leader>q', ':qa<CR>', { noremap = true, silent = true, desc = '[Q]uit all' })

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
            local servers = {
                clangd = {},
                rust_analyzer = {},
                pyright = {},
                tsserver = {},
                sumneko_lua = {
                    Lua = {
                        -- Suppress lots of 'Undefined global `vim`' warnings.
                        diagnostics = { globals = { 'vim' }, },
                        -- Do not send telemetry data containing a randomized but unique identifier.
                        telemetry = { enable = false },
                    }
                },
                gopls = {}
            }

            -- Send additional capabilities supported by nvim-cmp to LSP server.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then desc = 'LSP: ' .. desc end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap('<Leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<Leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<Leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<Leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                -- nmap('<Leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                -- nmap('<Leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                -- nmap('<Leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                -- nmap('<Leader>wl', function()
                --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                -- end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    if vim.lsp.buf.format then
                        vim.lsp.buf.format()
                    elseif vim.lsp.buf.formatting then
                        vim.lsp.buf.formatting()
                    end
                end, { desc = 'Format current buffer with LSP' })
            end

            require("mason").setup()
            require("mason-lspconfig").setup { ensure_installed = vim.tbl_keys(servers) }
            require("mason-lspconfig").setup_handlers {
                function(server)
                    require('lspconfig')[server].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server],
                    }
                end
            }
        end
    },

    -- Tree sitter support.
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help' },
                highlight = { enable = true, },
            }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },

    -- Auto-completion.
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local cmp = require('cmp')
            local snip = require('luasnip')

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
                        elseif snip.expand_or_jumpable() then
                            snip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-k>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif snip.jumpable(-1) then
                            snip.jump(-1)
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
                    { name = 'luasnip' },
                },
            }
        end
    },

    -- Theme inspired by Atom / VS Code.
    {
        'navarasu/onedark.nvim',
        config = function() require('onedark').load() end
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
        tag = '0.1.0',
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
            vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<Leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<Leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<Leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        end
    },

    -- Use fzf as sorter in Telescope. It's faster and supports fzf patterns such as 'exact matches.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1, -- Only load if `make` is available.
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function() require('telescope').load_extension('fzf') end
    },

    -- Use "gc" to comment visual regions/lines.
    {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    },

    -- Transparent background in Neovim. Does what it says on the tin.
    {
        'xiyaowong/nvim-transparent',
        config = function() require("transparent").setup { enable = true } end
    },

    {
        'cdelledonne/vim-cmake',
        config = function()
            vim.g.cmake_link_compile_commands = true -- Make symlink to compile_commands.json.
            -- vim.keymap.set('', '<Leader>cg', ':CMakeGenerate<CR>', { desc = '[C]Make [G]enerate' })
            -- vim.keymap.set('', '<Leader>cb', ':CMakeBuild<CR>', { desc = '[C]Make [B]uild' })
            -- vim.keymap.set('', '<Leader>cq', ':CMakeClose<CR>', { desc = '[C]Make [Q]uit' })
            -- vim.keymap.set('', '<Leader>cc', ':CMakeClean<CR>', { desc = '[C]Make [C]lean' })
        end
    },
}
