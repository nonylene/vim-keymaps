" Maintainer: nonylene
" License: MIT

scriptencoding utf-8

" line-continuation
let s:save_cpo = &cpo
set cpo&vim

" avoid force loading
if exists("g:loaded_keymaps")
  finish
endif
let g:loaded_keymaps = 1

" no default keymap

" if !hasmapto('<Plug>KeyMapRotate')
"   noremap <unique> <C-k> <Plug>KeyMapRotate
"   noremap! <unique> <C-k> <Plug>KeyMapRotate
" endif

" cnoremap <unique> <silent> <script> <Plug>KeyMapRotate <CR>:call KeyMapRotate()<CR>
noremap <unique> <silent> <script> <Plug>KeyMapRotate :<C-u>call KeyMapRotate()<CR>
noremap! <expr> <unique> <Plug>KeyMapRotate KeyMapRotate()

" autocmd
augroup keymaps
  autocmd!
  autocmd OptionSet paste call s:PasteOptionSet()
augroup END

" commands
if !exists(":KeyMapRotate")
  command -nargs=0 KeyMapRotate call KeyMapRotate()
endif

if !exists(":KeyMapSet")
  command -nargs=1 KeyMapSet call s:KeyMapSetName(<q-args>)
endif

function! s:PasteOptionSet()
  echo v:option_new
  " sometimes v:option_new not working
  if g:keymaps_paste_auto_rotate && !&paste && s:GetCurrentKeyMapName() is "paste"
    " exit paste mode -> rotate
    call KeyMapRotate()
  endif
endfunction

function s:GetCurrentKeyMapName()
  return g:keymaps[s:current_keymap_index]["name"]
endfunction

" rotate keymap
function! KeyMapRotate()
  if s:current_keymap_index + 1 > len(g:keymaps) - 1
    call s:KeyMapSetIndex(0, g:keymaps_unmap_keys)
  else
    call s:KeyMapSetIndex(s:current_keymap_index+1, g:keymaps_unmap_keys)
  endif
  " expr -> insert no chars
  return ''
endfunction

function! s:KeyMapSetName(name)
  call s:KeyMapSetIndex(s:name_index_dict[a:name], g:keymaps_unmap_keys)
endfunction

function! s:KeyMapSetIndex(index, do_unmap)
  let s:current_keymap_index = a:index
  let l:keymap = g:keymaps[a:index]

  if a:do_unmap
    if a:index - 1 < 0
      let l:old_keymap_index = len(g:keymaps) - 1
    else
      let l:old_keymap_index = a:index - 1
    endif

    let l:old_keymap = get(g:keymaps[l:old_keymap_index], 'keymap', {})

    " [cmd, map]
    for item in items(l:old_keymap)
      let l:uncmd = s:create_unmap(item[0])
      " [lhs, rhs]
      for lhs in keys(item[1])
        execute(l:uncmd . ' ' . lhs)
      endfor
    endfor

  endif

  if get(l:keymap, 'paste', 0)
    set paste
  elseif has_key(l:keymap, 'keymap')
    set nopaste
    " [cmd, map]
    for item in items(l:keymap['keymap'])
      let l:cmd = item[0]
      " [lhs, rhs]
      for pair in items(item[1])
        execute(l:cmd . ' ' . pair[0] . ' ' . pair[1])
      endfor
    endfor
  endif
endfunction

" initialize
if !exists('g:keymaps')
  let g:keymaps =  [
        \  {
        \    'name': 'default'
        \  },
        \  {
        \    'name': 'paste',
        \    'paste': 1
        \  },
        \]
endif

" create scope
function! s:init()
  " kaymap name to index dictionary
  let s:name_index_dict = {}

  for index in range(0, len(g:keymaps) - 1)
    let l:keymap = g:keymaps[index]
    let s:name_index_dict[l:keymap['name']] = index

    if !exists('g:keymaps_paste_auto_rotate') && get(l:keymap, 'paste', 0)
      " set paste auto rotate if paste exists in conf
      let g:keymaps_paste_auto_rotate = 1
    endif
  endfor

  " initial keymap
  if !exists('g:keymaps_default')
    let s:current_keymap_index = 0
  else
    let s:current_keymap_index = s:name_index_dict[g:keymaps_default]
  endif

  if !exists('g:keymaps_nopaste_auto_rotate')
    let g:keymaps_nopaste_auto_rotate = 0
  endif

  if !exists('g:keymaps_unmap_keys')
    let g:keymaps_unmap_keys = 1
  endif

  " initial -> not loading
  call s:KeyMapSetIndex(s:current_keymap_index, 0)
endfunction

function! s:create_unmap(origin)
  let l:first = a:origin[0]
  if l:first is 'n'
    if a:origin[1] is 'o'
      " noremap
      let l:cmd = 'unmap'
    else
      let l:cmd = 'nunmap'
    endif
  elseif l:first is 'm'
    " unmap
    let l:cmd = 'unmap'
  else
    let l:cmd = l:first . 'unmap'
  endif

  if a:origin =~ '!'
    let l:cmd .= '!'
  endif

  return l:cmd
endfunction

call s:init()

" end line-continuation
let &cpo = s:save_cpo
unlet s:save_cpo
