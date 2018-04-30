" File: jikoku.vim
" Author: Shinya Ohyanagi <sohyanagi@gmail.com>
" WebPage:  http://github.com/heavenshell/vim-jikoku/
" Description: Convert given timestamp to local date time and utc
" License: BSD, see LICENSE for more details.
" Copyright: 2018 Shinya Ohyanagi. All rights reserved.
let s:save_cpo = &cpo
set cpo&vim

function! s:add(ltime, utc, filename, line, col, mode)
  let text = printf(
    \ 'Local: %s UTC: %s',
    \ strftime('%Y-%m-%d %H:%M:%S', a:ltime),
    \ strftime('%Y-%m-%d %H:%M:%S', a:utc))

  let list = [{
    \ 'filename': a:filename,
    \ 'lnum': a:line,
    \ 'col': a:col,
    \ 'text': text,
    \ }]
  echomsg '[Jikoku] ' . text
  call setqflist(list, a:mode)
endfunction

function! s:utc(time)
  let tz = str2nr(matchstr(strftime('%z', a:time), '\v[+-]\zs[0-9]{2}\ze[0-9]'))
  let tz_sec = tz * 60 * 60
  return a:time - tz_sec
endfunction

function! s:info() abort
  let pos = getpos('.')
  let word = expand('<cword>')

  " pos[0] is lnum, pos[1] is col
  return { 'line': pos[1], 'col': pos[2], 'word': word, 'filename': expand('%p') }
endfunction

function! jikoku#run(...) abort
  " let ltime = localtime()
  let info = s:info()
  if (len(info['word']) != 10)
    return
  endif

  let mode = a:000[0] == 0 ? 'a' : 'r' " Jikoku! behave clear qflist and add
  let utc = s:utc(info['word'])
  call s:add(info['word'], utc, info['filename'], info['line'], info['col'], mode)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
