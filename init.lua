-- In insert mode, map jk to Escape to return to normal mode.
vim.keymap.set('i', 'jk', '<Esc>')

-- Display line numbers in front of each line.
vim.o.number = true

-- Make line numbers relative to the current position.
-- The line above and below the current line are both numbered 1
-- because they are relatively 1 line away from the current line.
vim.o.relativenumber = true

-- The "leader" is a key you can define and then use in keymaps like
-- vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
-- I use the space key as a leader.
vim.g.mapleader = ' '

-- ignorecase and smartcase together will make searches done with "/"
-- ignore case at first, unless you type a capital letter, in which
-- the search will become case sensitive.
vim.o.ignorecase = true
vim.o.smartcase = true

local install_lazy_plugin_manager = function(path_to_lazy)
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		path_to_lazy,
	})
end

-- Installs lazy plugin manager if it is not yet installed.
local path_to_lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_installed = vim.loop.fs_stat(path_to_lazy)
if not lazy_installed then
	install_lazy_plugin_manager(path_to_lazy)
end
vim.opt.rtp:prepend(path_to_lazy)

-- Its in lazy's setup function that you can specify what plugins you want and
-- their configuration. You can also configure plugins in other directories,
-- etc. Just checkout Lazy's readme.
require("lazy").setup({
	-- onedark is a color scheme.
	{
		"navarasu/onedark.nvim",
		config = function()
			require('onedark').setup {
				style = 'warm'
			}
			require('onedark').load()
			-- I found when writing parenthesis in comments
			-- that when the matching paren was highlighted,
			-- the foreground and background colors were the
			-- same and the bracket would turn invisible.
			-- This command sets the background color of the
			-- matching parenthesis to a darker color.
			vim.cmd('hi MatchParen guibg=#444444')
		end
	},
	-- treesitter is a parsing system, it builds and updates syntax trees.
	-- It's possible to use treesitter with Nvim to have really intelligent
	-- syntax highlighting and stuff. I think Nvim comes with and installs
	-- treesitter. nvim-treesitter is a package that's meant to make using
	-- Nvim's treesitter interface easier. It makes setting up language
	-- parsers easy, and provides syntax highlighting based on those
	-- parser's output.
	{
		"nvim-treesitter/nvim-treesitter",
		-- Because each version of nvim-treesitter only works with specific
		-- parser versions, each time we install or update nvim-treesitter,
		-- we have to update all of our installed parsers.
		build = ":TSUpdate",
		config = function () 
			-- Just what nvim-treesitter makes you do to set configs, have to
			-- use this configs module and call .setup() on it.
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				-- Makes these get installed right away if they
				-- aren't installed yet. Like for example if
				-- you've opened nvim for the first time.
				ensure_installed = {
					"typescript",
					"javascript",
					"html",
					"css",
					"vue",
					"lua",
				},
				-- Enables the parsers to be installed and
				-- setup async so nvim still opens fast when
				-- first opened and parsers in ensure_installed
				-- aren't installed yet.
				sync_install = false,
				-- Enables highlighting based off the built
				-- syntax tree.
				highlight = { enable = true },
				-- Makes the = command indent the right number
				-- of tabs/spaces.
				indent = { enable = true },
			})
		end
	},
	-- Telescope is a fuzzy finder over any lists. Made of pickers,
	-- sorters, and previewers, it can be user to fuzzy find files,
	-- language server results, and more.
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('telescope').setup{
				defaults = {
					mappings = {
						i = {
							-- This disables telescope's default
							-- mapping for Ctrl-u in insert mode
							-- from scrolling the preview window up.
							-- Instead, it will clear the prompt.
							["<C-u>"] = false
						},
					},
					-- This will change the layout of
					-- telescope so it fits well in skinny
					-- windows.
					layout_strategy = 'vertical',
					layout_config = {
						preview_cutoff = 22
					}
				}
			}
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
		end
	},
	-- nvim-lspconfig: Nvim supports the Language Server Protocol (LSP). If you have
	-- language servers available on your computer, then Nvim can connect to them
	-- and provide cool features like jumping to definition, renaming, etc. Nvim
	-- has to be configured for each language server, which can be hard to configure
	-- it correctly, so this plugin nvim-lspconfig provides some ready-to-go configs.
	-- You can checkout `:help lspconfig-all` to see the list of configurations, and
	-- installation instructions to get the respective language server on your computer.
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			local lspconfig = require('lspconfig')
			-- nvim-cmp supports more LSP capabilities than omnifunc.
			-- We will want to inform language servers of this.
			local nvim_cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- LSP for Vue 3
			lspconfig.volar.setup {
				-- Turns on 'Take Over Mode' so volar becomes the language
				-- server for TypeScript files and can provide proper
				-- support for .vue files imported into TypeScript files.
				filetypes = {
					'typescript',
					'javascript',
					'javascriptreact',
					'typescriptreact',
					'vue',
					'json'
				},
				init_options = {
					typescript = {
						-- Some projects I use volar in that are js projects
						-- don't have typescript as a dependency, so here
						-- I point volar to use a globally installed typescript.
						-- Should see if I can do node/**/bin in file path
						-- so it can use any version. Or make a version that 
						-- uses the current node version from nvm in the file path.
						tsdk = '/Users/dylan/.nvm/versions/node/v19.6.1/lib/node_modules/typescript/lib'
					}
				},

				capabilities = nvim_cmp_capabilities
			}

			-- Config for Markdown language server.
			-- Big reason I want it is that in addition to regular markdown features like
			-- linking between files `[link to yesterday's file](/yesterday.md)`, marksman
			-- supports linking to specific headers in a file:
			-- `[link to yesterday's file](/yesterday)`
			lspconfig.marksman.setup {
				capabilities = nvim_cmp_capabilities
			}

			-- Below we register keymaps after Nvim attaches to a language server.
			-- This autocmd will run whenever the LspAttach event fires.
			vim.api.nvim_create_autocmd('LspAttach', {
				-- Puts this autocmd in a group. Useful for organizing
				-- and using the group name as an identifier to later
				-- remove them. :help autocmd-groups
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				-- This is the event handler when the autocommand runs.
				callback = function(ev)
					-- The LspAttach event includes which buffer was attached.
					-- We can use this buffer number when registering keymaps
					-- to make the keymap only work in that buffer.
					local options = { buffer = ev.buf }
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, options)
					vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, options)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, options)
					-- References are anywhere a symbol appears. Shows a list of symbol
					-- occurences informed by usage provided by the language server.
					-- Upon navigating, puts the cursor on the occurence.
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, options)
					-- The implementation is where a symbol is used.
					-- If you do it on a base class, shows a list of derived classes.
					-- If you do it on a type, shows a list of variables with that type.
					-- Upon navigating, puts the cursor on the symbol which implements the original symbol.
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, options)
					vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, options)
					vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, options)
					vim.keymap.set({ 'n' }, ']d', vim.diagnostic.goto_next, options)
					vim.keymap.set({ 'n' }, '[d', vim.diagnostic.goto_prev, options)
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)

					-- TODO: install, configure, test
					-- require("lsp_signature").on_attach({}, ev.buf)
				end,
			})
		end
	},
	-- Autocompletion plugin. It's the fancy window that automatically appears and as
	-- you type and fills with suggestions. A replacement of vim's omnifunc manual
	-- completion tool.
	-- For it to work "completion sources" must be installed and "sourced". nvim-cmp
	-- will handle the rest.
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- LSP source for nvim-cmp. Lets nvim-cmp work with the language server's
			-- completion results.
			'hrsh7th/cmp-nvim-lsp',
			-- nvim-cmp needs a snippet engine to work.
			'L3MON4D3/LuaSnip',
			-- This is the source for nvim-cmp to connect to luasnip
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
					['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-k>'] = cmp.mapping.close(),
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
				cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
						else
				fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
				cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
						else
				fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			}
		end
	},
	-- A plugin that provides a file manager window!
	'preservim/nerdtree',
	-- Git plugin that lets you manage git and view diffs in vim
	'tpope/vim-fugitive',
	-- Shows +/- in the sign column next to the line numbers
	-- according to if those lines have been changed.
	'airblade/vim-gitgutter'
})
