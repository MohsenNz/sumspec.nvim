# sumspec.nvim

Neovim support for [SumSpec](https://github.com/MohsenNz/sumspec), a
language for writing an application's spec as types and state
transitions.

- The `sumspec` filetype, for files ending in `.sumspec`.
- The language server's configuration: diagnostics as you edit, the
  outline, go to definition, references and semantic highlighting.
- A syntax file that colours a spec before the server attaches, and the
  parts the server leaves alone.
- Spell checking in comments only, not in names like `FileState`.
- `--` comments for `gc`.

## Requirements

- Neovim 0.11 or later.
- `sumspec` on your `PATH`. From a clone of the
  [sumspec](https://github.com/MohsenNz/sumspec) repository:

  ```
  nix profile add .
  ```

  To update it later: `nix profile upgrade sumspec`.

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "mohsennz/sumspec.nvim",
  config = function()
    vim.lsp.enable("sumspec")
  end,
}
```

Or with any other plugin manager, or as a package
(`~/.local/share/nvim/site/pack/plugins/start/sumspec.nvim`), and then
in your `init.lua`:

```lua
vim.lsp.enable("sumspec")
```

Open a spec; `:checkhealth vim.lsp` shows whether the server is
attached.

## Use

- `gO`: the outline.
- `CTRL-]`: go to the definition of a type, variant, event, annotation,
  constant or value (`x` goes to its `#x`). Neovim doesn't map `gd` to
  it; `vim.keymap.set("n", "gd", vim.lsp.buf.definition)` does.
- `grr`: every reference to the name under the cursor.
- `:Inspect` on a name shows its semantic token and highlight group.

The server logs to stderr, which Neovim writes to its LSP log
(`:lua vim.cmd.edit(vim.lsp.get_log_path())`).

## Configure

The server's settings are in `lsp/sumspec.lua`. Change them with
`vim.lsp.config`, before `vim.lsp.enable`. For example, to run a
`sumspec` that isn't on your `PATH`:

```lua
vim.lsp.config("sumspec", { cmd = { "/path/to/sumspec", "lsp" } })
```

The semantic tokens use Neovim's groups `@lsp.type.<type>.sumspec`:
`type`, `enumMember` (a variant), `event`, `variable` (a value, or a
constant with the `readonly` modifier), `decorator` (an annotation),
`keyword`, `operator`, `string`, `number` and `comment`.
`ftplugin/sumspec.vim` links them to the usual tree-sitter groups
(`@type`, `@constant`, `@function`, ...) with `highlight default link`,
so your colour scheme or a `:highlight` command can set them instead:

```lua
vim.api.nvim_set_hl(0, "@lsp.type.event.sumspec", { link = "Title" })
```

A guard (`// ...` up to its `->`) is dimmed, so the source and target
stand out: its names, values and operators take the group
`sumspecGuard`, linked to `Comment`; its `//` and its words (`not`,
`and`, `or`, `in`) keep their colours. The arguments of an annotation
(`@effect snackbar "Saved"`) are opaque text, so they are dimmed too,
as the group `sumspecAnnotationArgs`, also linked to `Comment`; the
`@name` keeps its colour. The server sends no tokens for them, so this
needs a `sumspec` that has that change. To change either:

```lua
vim.api.nvim_set_hl(0, "sumspecGuard", { link = "NonText" })
vim.api.nvim_set_hl(0, "sumspecAnnotationArgs", { link = "NonText" })
```

## Keeping in sync

`syntax/sumspec.vim` follows the grammar in the sumspec repository
(`spec/grammar.ebnf`). A change to the language's words or operators
changes it too.
