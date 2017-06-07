# vim-keymaps

keymap switcher for Vim

![ScreenCast](/doc/screencast.gif)

_( Using [lightline](https://github.com/itchyny/lightline.vim) for statusline. )_

## Install

- VimPlug

```vim
Plug 'nonylene/vim-keymaps'
```

## Configuration

First, map keys to this plugin as you like.

```vim
" map any key to <Plug>KeyMapRotate

map <C-k> <Plug>KeyMapRotate
imap <C-k> <Plug>KeyMapRotate

" Call function in order to switch to explicit keymap

" noremap <silent> <script> <C-p> :call keymaps#set_keymap("US")<CR>
" noremap! <expr> <C-p> keymaps#set_keymap("US")

" If you will use paste mode, this is recommended

" set pastetoggle=<C-k>
```

Keymaps are configured as array of dictionaries.

```vim
let g:keymaps =  [
      \  {
      \    'name': 'first',
      \    'keymap': {
      \      'noremap': {
      \        '1': '!',
      \        '!': '1',
      \      },
      \      'inoremap': {
      \        "'": '"',
      \        '¥': '\',
      \      },
      \    },
      \  },
      \  {
      \    'name': 'second',
      \    'keymap': {
      \      'cnoremap': {
      \        '1': '@',
      \        ':': ';',
      \        ';': ':',
      \      },
      \      'inoremap <unique>': {
      \        '¥': '\|',
      \      },
      \    },
      \  },
      \  {
      \    'name': 'paste_mode',
      \    'paste': 1
      \  },
      \]
```

You can use `<Plug>`, `<SID>`, etc .

- IMPORTANT:

`<SID>` refers this plugin's scope because mappings are executed with plugin's scope. For that, functions used for `<expr>` mappings must be global.

```vim
let g:keymaps =  [
      \  {
      \    'name': 'first',
      \    'keymap': {
      \      'imap': {
      \        '2': '<Plug>delimitMate"',
      \        '7': "<Plug>delimitMate'",
      \      },
      \    },
      \  },
      \  {
      \    'name': 'second',
      \    'keymap': {
      \      'inoremap': {
      \        '<SID>parenthese': '()<Esc>i',
      \      },
      \      'noremap! <script>': {
      \        '8': '<SID>parenthese',
      \      },
      \      'imap <expr>': {
      \        '1': 'Foo()',
      \      },
      \    },
      \  },
      \]
```

## Other options

- `g:keymaps_unmap_keys` (default: 1)

Unmap prev keymaps before do mapping.

- `g:keymaps_paste_auto_rotate` (default: 1 (if `'paste': 1` exists) / 0)

Rotate keymap after exit paste mode (using hook OptionChange). 

"7.4.786" patch is required to enable this feature.

- `g:keymaps_default`

First used keymap name. If not set, first keymap in array will be used.

## Commands

- `KeyMapRotate`

Switch to next keymap.

- `KeyMapSet <keymap_name>`

Switch to explicit keymap.

## Tips

- Get current keymap name

`:call keymaps#get_current_keymap_name`

## License

MIT License (see License.md).
