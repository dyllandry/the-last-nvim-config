# Readme

This is Dylan Landry's last vim config. It will:

1. explain everything
1. be forever maintained
1. be heckin good

## Todo

- setup LSP stuff
  - briefly try out existing setup, check if need a completion window plugin like Coc/you-complete-me or whatever
  - test against with new vite project against VSCode
- lualine + lualine-lsp-progress
- show tabs as 4 spaces instead of 8
- plugin for detecting indent settings
  - make sure it plays well with TS indent module. I'm not sure how those interact.
- setup git fugitive

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

## LSP oh lordy

- `:help lsp`: Guide on LSP
- `:help lsp-quickstart`

**Language Server Protocol**: "The Language Server Protocol (LSP) defines the protocol used between an editor or IDE and a language server that provides language features like auto complete, go to definition, find all references etc."

More here: <https://microsoft.github.io/language-server-protocol/>

List of language servers: <https://microsoft.github.io/language-server-protocol/implementors/servers/>

Nvim supports LSP and can act as a client to LSP servers.

Nvim provides a lua framework `vim.lsp` for building LSP enhanced tools.

1. Install language servers on your computer
2. Configure LSP client per language server. See `vim.lsp.start()`

```lua
vim.lsp.start({
  name = 'my-server-name',
  cmd = {'name-of-language-server-executable'},
  root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
})
```

3. Configure keymaps and autocmd to use LSP features. See `lsp-config`

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
  end,
})
```

Because not all language servers provide the same capabilities, you can first check if those things are supported. Instructions on this are in `:help lsp-config`.

You can use nvim-lspconfig which provides ready-to-go configs for many langauge servers as well as installation instructions for how to get the actual language servers on your computer.

