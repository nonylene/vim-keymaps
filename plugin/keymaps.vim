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

" command
if !exists(":KeyMapRotate")
  command -nargs=0 KeyMapRotate :call s:KeyMapRotate()
endif

function s:KeyMapRotate()
  echo "Hello world!"
endfunction


" end line-continuation
let &cpo = s:save_cpo
unlet s:save_cpo

