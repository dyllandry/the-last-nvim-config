-- In insert mode, map jk to Escape to return to normal mode.
vim.keymap.set('i', 'jk', '<Esc>')

-- Display line numbers in front of each line.
vim.o.number = true

-- Make line numbers relative to the current position.
-- The line above and below the current line are both numbered 1
-- because they are relatively 1 line away from the current line.
vim.o.relativenumber = true
