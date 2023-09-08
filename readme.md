# Readme

This is Dylan Landry's last vim config. It will:

1. explain everything
1. be forever maintained
1. be heckin good

## Tips

You can use `gO` (capital "o") to see an outline of a help file.

## A guide to using nvim

`:help user-manual`

## Configuring Vim with Lua

`:help lua-guide`: A survival guide on configuring nvim with Lua.

You can interact with Neovim through Lua in three "layers":

- "Vim API" for ex-commands through `vim.cmd()` and user functions in Vimscript through `vim.fn`
- "Neovim API" through `vim.api`
- "Lua API" through other functions in `vim.*`

## Lua

- `:help luaref`: A reference on the Lua programming language
- `:help lua-concepts`: Describes major concepts behind Lua
- `:help lua-engine`: All about the Lua engine in neovim
