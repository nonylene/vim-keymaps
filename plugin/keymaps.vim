" Maintainer: nonylene
" License: MIT

scriptencoding utf-8

" avoid force loading
if exists("g:loaded_keymaps")
  finish
endif
let g:loaded_keymaps = 1

" line-continuation
let s:save_cpo = &cpo
set cpo&vim

call keymaps#init()

" cnoremap <unique> <silent> <script> <Plug>KeyMapRotate <CR>:call KeyMapRotate()<CR>
noremap <unique> <silent> <script> <Plug>KeyMapRotate :<C-u>call keymaps#rotate_keymap()<CR>
noremap! <expr> <unique> <Plug>KeyMapRotate keymaps#rotate_keymap()

" commands
if !exists(":KeyMapRotate")
  command -nargs=0 KeyMapRotate call keymaps#rotate_keymap()
endif

if !exists(":KeyMapSet")
  command -nargs=1 KeyMapSet call keymaps#set_keymap(<q-args>)
endif

" autocmd
augroup keymaps
  autocmd!
  autocmd OptionSet paste call s:on_change_paste()
augroup END

function! s:on_change_paste()
  echo v:option_new
  " sometimes v:option_new not working
  if g:keymaps_paste_auto_rotate && !&paste && keymaps#get_current_keymap_name() is "paste"
    " exit paste mode -> rotate
    call keymaps#rotate_keymap()
  endif
endfunction

" end line-continuation
let &cpo = s:save_cpo
unlet s:save_cpo
