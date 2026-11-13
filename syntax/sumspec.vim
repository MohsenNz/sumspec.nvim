" Vim syntax file for SumSpec. The language is defined in the sumspec
" repository: spec/spec-v1.md and spec/grammar.ebnf.
"
" A fallback: the language server's semantic tokens colour the names by
" what they are and override this once it attaches. This file colours a
" spec before then, and the parts the server leaves alone (operators,
" brackets, a definition that doesn't parse).
"
" Keep it in sync with the grammar when the language changes.

if exists('b:current_syntax')
  finish
endif

syntax case match

" A guard can span lines: parse from the start so a line inside one knows
" it is. Specs are small, so this is cheap.
syntax sync fromstart

" Spell-check comments only, not names like FileState or checkoutCommit.
syntax spell notoplevel

" Names: a type or variant starts upper case; after a dot it's usually a
" variant. An event is defined at the start of a line.
syntax match sumspecType '\<\u\w*'
syntax match sumspecVariant '\.\s*\zs\u\w*'
syntax match sumspecEvent '^\l\w*'
syntax match sumspecNaming '#\l\w*'
" An annotation's arguments are opaque text (grammar: ARGUMENTS): dimmed,
" up to the end of the line, a comment, or, outside brackets, one of
" @ = | * :: or an unmatched closing bracket. Brackets nest and may span
" lines; a string is one unit.
syntax match sumspecAnnotation '@\l\w*' nextgroup=sumspecAnnotationArgs skipwhite
syntax region sumspecAnnotationArgs contained
      \ start='\%([@=|*)\]}]\|::\|--\)\@!\S'
      \ end='$' end='\ze--' end='\ze\%([@=|*)\]}]\|::\)'
      \ contains=sumspecArgBrackets,sumspecArgString
syntax region sumspecArgBrackets contained matchgroup=sumspecAnnotationArgs start='(' end=')' contains=sumspecArgBrackets,sumspecArgString,sumspecComment
syntax region sumspecArgBrackets contained matchgroup=sumspecAnnotationArgs start='\[' end=']' contains=sumspecArgBrackets,sumspecArgString,sumspecComment
syntax region sumspecArgBrackets contained matchgroup=sumspecAnnotationArgs start='{' end='}' contains=sumspecArgBrackets,sumspecArgString,sumspecComment
syntax region sumspecArgString contained start=+"+ end=+"+ oneline

" __atomics, __events, __annotations, __init, __version, __int, ...
syntax match sumspecKeyword '\<__\a\w*'
" Words only in a guard, a list type or an element path (L[each #x in xs]).
syntax keyword sumspecKeyword by not and or in each

syntax match sumspecNumber '\<\d\+\%(\.\d\+\)\=\>'
syntax region sumspecString start=+"+ end=+"+ oneline

syntax match sumspecOperator '::\|->\|=>\|//\|==\|!=\|<=\|>=\|[-|*+=<>/'']'

" A guard, from // up to its ->: dimmed, so the source and target stand
" out. Its words and a comment keep their colours. A blank line ends a
" guard with no -> (a parse error).
syntax region sumspecGuard matchgroup=sumspecOperator start='//' end='\ze->' end='^\s*$' keepend contains=sumspecKeyword,sumspecComment

" Last, so that -- wins over the - operator.
syntax keyword sumspecTodo TODO FIXME XXX contained
syntax match sumspecComment '--.*$' contains=@Spell,sumspecTodo

highlight default link sumspecType Type
highlight default link sumspecVariant Constant
highlight default link sumspecEvent Function
highlight default link sumspecNaming Identifier
highlight default link sumspecAnnotation PreProc
highlight default link sumspecKeyword Keyword
highlight default link sumspecNumber Number
highlight default link sumspecString String
highlight default link sumspecOperator Operator
highlight default link sumspecGuard Comment
highlight default link sumspecAnnotationArgs Comment
highlight default link sumspecArgBrackets sumspecAnnotationArgs
highlight default link sumspecArgString sumspecAnnotationArgs
highlight default link sumspecComment Comment
highlight default link sumspecTodo Todo

let b:current_syntax = 'sumspec'
