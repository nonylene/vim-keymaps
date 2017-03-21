# vim-keymaps
[WIP] vim keymap change plugin

## Install

- VimPlug

```vim
Plug 'nonylene/vim-keymaps'
```

## Config

```vim
" map any key to <Plug>KeyMapRotate
map <C-k> <Plug>KeyMapRotate
map! <C-k> <Plug>KeyMapRotate

" map <Plug>KeyMapSet_<name> to change explicit keymap
map <C-s> <Plug>KeyMapSet_second
map <C-p> <Plug>KeyMapSet_paste

" If you use paste mode, this is recommended
set pastetoggle=<C-k>

" keymaps
let g:keymaps =  [
      \  {
      \    'name': 'JP',
      \    'keymap': {
      \      'noremap!': {
      \        '1': '!',
      \        '!': '1',
      \      },
      \      " You can use <Plug>
      \      'imap': {
      \        '2': '<Plug>delimitMate"',
      \        '7': "<Plug>delimitMate'",
      \      },
      \      'cnoremap': {
      \        '2': '"',
      \        '7': "'",
      \      },
      \    },
      \  },
      \  {
      \    'name': 'second',
      \    'keymap': {
      \      " XXX: This is executed with plugin's scope.
      \      "      <SID> also refers plugin's scope.
      \      'inoremap': {
      \        '<SID>parenthese': '()<Esc>i',
      \      },
      \      'cnoremap': {
      \        '<SID>parenthese': '(',
      \      },
      \      'noremap! <script>': {
      \        '8': '<SID>parenthese',
      \      },
      \      " Evaluated function must be global.
      \      'imap <expr>': {
      \        '1': 'Foo()',
      \      },
      \    },
      \  },
      \  {
      \    'name': 'paste',
      \    " You can also use paste mode.
      \    'paste': 1
      \  },
      \]
```

## Other options

- `g:keymaps_unmap_keys (default: 1)`

Unmap prev keymaps before do mapping.

- `g:keymaps_nopaste_auto_rotate (default: 1 (if "'paste': 1" exists) / 0)`

Rotate keymap after exit paste mode (using hook OptionChange). 

- `g:keymaps_default`

First used keymap name. If not set, first keymap in array will be used.


## Command

- `KeyMapRotate`

Change to next keymap.

- `KeyMapSet <keymap_name>`

Change to explicit keymap.

## License

MIT License (see License.md).
