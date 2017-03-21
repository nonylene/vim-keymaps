" Maintainer: nonylene
" License: MIT

scriptencoding utf-8

" line-continuation
let s:save_cpo = &cpo
set cpo&vim

function! keymaps#init()
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

  if !exists('g:keymaps_paste_auto_rotate')
    let g:keymaps_paste_auto_rotate = 0
  endif

  if !exists('g:keymaps_unmap_keys')
    let g:keymaps_unmap_keys = 1
  endif

  " initial -> not loading
  call s:set_keymap_index(s:current_keymap_index, 0)
endfunction

" rotate keymap
function! keymaps#rotate_keymap()
  if s:current_keymap_index + 1 > len(g:keymaps) - 1
    call s:set_keymap_index(0, g:keymaps_unmap_keys)
  else
    call s:set_keymap_index(s:current_keymap_index+1, g:keymaps_unmap_keys)
  endif
  " expr -> insert no chars
  return ''
endfunction

function! keymaps#get_current_keymap_name()
  return keymaps#get_current_keymap()["name"]
endfunction

function! keymaps#get_current_keymap()
  return g:keymaps[s:current_keymap_index]
endfunction

function! keymaps#set_keymap(name)
  call s:set_keymap_index(s:name_index_dict[a:name], g:keymaps_unmap_keys)
endfunction

function! s:set_keymap_index(index, do_unmap)
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

" end line-continuation
let &cpo = s:save_cpo
unlet s:save_cpo
