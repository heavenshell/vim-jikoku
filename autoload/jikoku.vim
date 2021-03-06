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
  let hm = map(split(strftime('%H %M', 0), ' '), 'str2nr(v:val)')
  if str2nr(strftime('%Y', 0)) != 1970
    let tz_sec = 60*60*24 - hm[0] * 60*60 - hm[1] * 60
  else
    let tz_sec = hm[0] * 60*60 + hm[1] * 60
  endif
  return a:time - tz_sec
endfunction

function! s:info() abort
  let pos = getpos('.')
  let word = expand('<cword>')

  " pos[1] is lnum, pos[2] is col
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
