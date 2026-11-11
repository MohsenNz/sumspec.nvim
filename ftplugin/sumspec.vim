" Vim filetype plugin for SumSpec.

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=--\ %s
setlocal comments=:--
" Comments name types such as FileState: check each part of the word.
setlocal spelloptions+=camel

let b:undo_ftplugin = 'setlocal commentstring< comments< spelloptions<'

" Colours for the language server's semantic tokens. Neovim names a
" token's group @lsp.type.<type>.<filetype>; without these, many colour
" schemes leave events and values plain. A colour scheme may still set
" its own, and a colour scheme change clears them, so set them again.
function! s:semantic_links() abort
  highlight default link @lsp.type.type.sumspec @type
  highlight default link @lsp.type.enumMember.sumspec @constant
  highlight default link @lsp.type.event.sumspec @function
  highlight default link @lsp.type.variable.sumspec @variable.parameter
  highlight default link @lsp.typemod.variable.readonly.sumspec @constant
  highlight default link @lsp.type.decorator.sumspec @attribute
  highlight default link @lsp.type.keyword.sumspec @keyword
  highlight default link @lsp.type.operator.sumspec @operator
  highlight default link @lsp.type.string.sumspec @string
  highlight default link @lsp.type.number.sumspec @number
  highlight default link @lsp.type.comment.sumspec @comment
endfunction

call s:semantic_links()

augroup sumspec_semantic_links
  autocmd!
  autocmd ColorScheme * call s:semantic_links()
augroup END
