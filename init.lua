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
	}
})
