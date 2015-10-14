" Location list extension for CtrlP
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  14-Oct-2015.
" License:      Vim License  (see :help license)
" Credits:      Kien Nguyen <github.com/kien> {{{
"     Create based on:
"     ctrlp.vim/autoload/ctrlp/quickfix.vim
"     Vim License  (see :help ctrlp-credits)
" }}}

if exists('g:loaded_ctrlp_location_list') && g:loaded_ctrlp_location_list
  finish
endif
let g:loaded_ctrlp_location_list = 1

call add(g:ctrlp_ext_vars, {
\ 'init'   : 'ctrlp#location_list#init(s:crbufnr)',
\ 'accept' : 'ctrlp#location_list#accept',
\ 'lname'  : 'location_list',
\ 'sname'  : 'loc',
\ 'exit'   : 'ctrlp#location_list#exit()',
\ 'type'   : 'line',
\ 'sort'   : 0,
\ 'nolim'  : 1})

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! s:lineout(dict)
  return printf('%s|%d:%d| %s', bufname(a:dict['bufnr']), a:dict['lnum'],
  \ a:dict['col'], matchstr(a:dict['text'], '\s*\zs.*\S'))
endfunction

function! s:syntax()
  if !ctrlp#nosy()
    call ctrlp#hicheck('CtrlPqfLineCol', 'Search')
    syntax match CtrlPqfLineCol '|\zs\d\+:\d\+\ze|'
  endif
endfunction

function! ctrlp#location_list#init(bufnr)
  let bufnr = exists('s:bufnr') ? s:bufnr : a:bufnr
  let bufs = exists('s:clmode') && s:clmode ? ctrlp#buffers('id') : [bufnr]
  call filter(bufs, 'v:val > 0')
  let lines = []
  for each in bufs
    call extend(lines, map(getloclist(each), 's:lineout(v:val)'))
  endfor
  call s:syntax()
  return lines
endfunction

function! ctrlp#location_list#accept(mode, str)
  let vals = matchlist(a:str, '^\([^|]\+\ze\)|\(\d\+\):\(\d\+\)|')
  if vals == [] || vals[1] == ''
    return
  endif
  call ctrlp#acceptfile(a:mode, vals[1])
  let cur_pos = getpos('.')[1:2]
  if cur_pos != [1, 1] && cur_pos != map(vals[2:3], 'str2nr(v:val)')
    mark '
  endif
  call cursor(vals[2], vals[3])
  silent! normal! zvzz
endfunction

function! ctrlp#location_list#cmd(mode, ...)
  let s:clmode = a:mode
  if a:0 && !empty(a:1)
    let s:clmode = 0
    let bname = a:1 =~# '^%$\|^#\d*$' ? expand(a:1) : a:1
    let s:bufnr = bufnr('^' . fnamemodify(bname, ':p') . '$')
  endif
  return s:id
endfunction

function! ctrlp#location_list#exit()
  unlet! s:clmode s:bufnr
endfunction
