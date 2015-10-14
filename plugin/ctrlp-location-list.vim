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

command! -nargs=? -complete=buffer
\ CtrlPLocList
\ call ctrlp#init(ctrlp#location_list#cmd(0, <q-args>))
command! -bar
\ CtrlPLocListAll
\ call ctrlp#init(ctrlp#location_list#cmd(1))
