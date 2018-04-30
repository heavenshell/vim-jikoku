" File: jikoku.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" WebPage:  http://github.com/heavenshell/vim-jikoku/
" Description: Convert given timestamp to local date time and utc
" License: BSD, see LICENSE for more details.
" Copyright: 2018 Shinya Ohyanagi. All rights reserved.
let s:save_cpo = &cpo
set cpo&vim

if get(b:, 'loaded_jikoku')
  finish
endif

command! -bang Jikoku :call jikoku#run(<bang>0)

let b:loaded_jikoku = 1

let &cpo = s:save_cpo
unlet s:save_cpo
