" forked form https://github.com/k-takata/vim-dosbatch-indent
" renamed to batch


if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent
setlocal noautoindent
setlocal indentexpr=GetBatchIndent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal indentkeys+=0=)

if exists("*GetBatchIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function! GetBatchIndent(lnum)
  let l:prevlnum = prevnonblank(a:lnum-1)
  if l:prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let l:prevl = substitute(getline(l:prevlnum), '\c^\s*\%(@\s*\)\?rem\>.*$', '', '')
  let l:thisl = getline(a:lnum)
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~? '^\s*@\=if\>.*(\s*$' ||
        \ l:prevl =~? '\<do\>\s*(\s*$' ||
        \ l:prevl =~? '\<else\>\s*\%(if\>.*\)\?(\s*$' ||
        \ l:prevl =~? '^.*\(&&\|||\)\s*(\s*$'
    " previous line opened a block
    let l:ind += shiftwidth()
  endif
  if l:thisl =~ '^\s*)'
    " this line closed a block
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8 sw=2 sts=2
