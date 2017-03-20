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

" map
if !hasmapto('<Plug>KeyMapRotate')
  map <unique> <C-p> <Plug>KeyMapRotate
endif

noremap <unique> <silent> <script> <Plug>KeyMapRotate :call <SID>KeyMapRotate()<CR>

" commands
if !exists(":KeyMapRotate")
  command -nargs=0 KeyMapRotate call s:KeyMapRotate()
endif

if !exists(":KeyMapSet")
  command -nargs=1 KeyMapSet call s:KeyMapSetName(<q-args>)
endif

" rotate keymap
function! s:KeyMapRotate()
  if s:current_keymap_index + 1 > len(g:keymaps) - 1
    call s:KeyMapSetIndex(0)
  else
    call s:KeyMapSetIndex(s:current_keymap_index+1)
  endif
endfunction

function! s:KeyMapSetName(name)
  call s:KeyMapSetIndex(s:name_index_dict[a:name])
endfunction

function! s:KeyMapSetIndex(index)
  let s:current_keymap_index = a:index
  let l:keymap = g:keymaps[a:index]
  if get(l:keymap, 'paste', 0)
    set paste
  else
    set nopaste
  end
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

" kaymap name to index dictionary
let s:name_index_dict = {}

for index in range(0, len(g:keymaps) - 1)
  let s:name_index_dict[g:keymaps[index]['name']] = index
endfor

" initial keymap
if !exists('g:keymaps_default')
  let s:current_keymap_index = 0
else
  let s:current_keymap_index = s:name_index_dict[g:keymaps_default]
end

call s:KeyMapSetIndex(s:current_keymap_index)

" end line-continuation
let &cpo = s:save_cpo
unlet s:save_cpo
