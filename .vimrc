" vim:ts=8
"
" vim 7 config
" joshua stein <jcs@jcs.org>
"

" defaults for everything
let c_minlines=500				" confoozled
set backspace=indent,eol,start			" yeah.
set hidden					" hidden buffers?
set ignorecase					" make searching fun
set incsearch                                   " but highlight as i type
set laststatus=2				" always
set modelines=5                                 " explicitly enable on mac os
set nofoldenable				" this shit is annoying
set nohlsearch                                  " don't highlight matches
set nostartofline				" yeah, sure
set pastetoggle=<C-p>				" control+p to toggle pasting
set ruler					" always show ruler
set scrolloff=10				" context is good
set shiftwidth=4				" match default tab spacing
set showcmd					" tell me what i'm doing
set showmatch					" where'd the opening ')' go?
set showmode					" where am i?
set smartcase					" be smart about searching
set spellfile=~/.vimspell.add			" my goodwords
set tabstop=4					" default tabs at 4 spaces
set viminfo=					" annoying!

set t_Co=256					" use all 256 colors
syntax on					" and enable syntax highlighting
colorscheme jcs					" and load my colors

" don't pollute directories with swap files, keep them in one place
silent !mkdir -p ~/.vim/{backup,swp}/
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" file type-specific settings

" .phtml are php files
au BufNewFile,BufRead *.phtml set ft=php

" these are rubyish files
au BufNewFile,BufRead *.rake,*.mab set ft=ruby
au BufNewFile,BufRead *.erb set ft=eruby

au BufNewFile,BufRead *.pjs set ft=javascript

" ruby - what tabs?
au FileType ruby,eruby set ts=2 sw=2 tw=79 et sts=2 autoindent
" and your yaml
au FileType yaml set ts=2 sw=2 et

" source code gets wrapped at <80 and auto-indented
au FileType asm,javascript,php,html,perl,c,cpp set tw=79 autoindent

" makefiles and c have tabstops at 8 for portability
au FileType make,c,cpp,objc set ts=8 sw=8

" email - expand tabs, wrap at 68 for future quoting, enable spelling
au FileType mail set tw=68 et spell spelllang=en_us

" cvs - commit messages are like email
au FileType cvs set tw=68 et

" and make sure there's a blank line for me to start typing (openbsd's cvs does
" this by default)
autocmd FileType cvs s/^CVS:/CVS:/|1


" macros

" control+d - delete the current line and all remaining text of an email up to
" the line of my signature (or the rest of the file) - useful for deleting lots
" of useless quoted text
function KillToSig ()
  let curline = line(".")
  if search("^-- ") > 0
    exec curline
    normal! ^d/^-- /O
    exec curline
  else
    normal! dGo
  endif
endfunction
map  <Esc>:let curline=line("."):exec KillToSig():exec curline

" control+t - refresh
map  :syn sync ccomment cComment minlines=500


" me fail english?  that's unpossible!
abbr seperate separate
abbr furnature furniture
abbr rediculous ridiculous
abbr definetly definitely
abbr shold should
abbr appologize apologize
abbr propogate propagate

" i hold shift a lot, make :W work like :w and :Q like :q
cabbr W w
cabbr Q q
