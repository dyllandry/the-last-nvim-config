-- In insert mode, map jk to Escape to return to normal mode.
vim.keymap.set('i', 'jk', '<Esc>')

-- Display line numbers in front of each line.
vim.o.number = true

-- Make line numbers relative to the current position.
-- The line above and below the current line are both numbered 1
-- because they are relatively 1 line away from the current line.
vim.o.relativenumber = true

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

local path_to_lazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_installed = vim.loop.fs_stat(path_to_lazy)
if not lazy_installed then
	install_lazy_plugin_manager(path_to_lazy)
end
vim.opt.rtp:prepend(path_to_lazy)

require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		config = function()
			require('onedark').setup {
				style = 'warm'
			}
			require('onedark').load()
		end
	}
})
