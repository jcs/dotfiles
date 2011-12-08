" vim:ts=8
"
" vim 7 config " joshua stein <jcs@jcs.org>
"

" defaults for everything
let c_minlines=500
set backspace=indent,eol,start
set hidden
set ignorecase					" make searching fun
set incsearch					" but highlight as i type
set laststatus=2
set modelines=5                                 " explicitly enable on mac os
set nofoldenable				" this shit is annoying
set nohlsearch					" don't highlight matches
set nostartofline
set pastetoggle=<C-p>				" control+p to toggle pasting
set ruler
set scrolloff=10				" context is good
set shiftwidth=4				" match default tab spacing
set showcmd
set showmatch					" where'd the opening ')' go?
set showmode
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

autocmd FileType * setlocal colorcolumn=0

" .phtml are php files
au BufNewFile,BufRead *.phtml set ft=php

" these are rubyish files
au BufNewFile,BufRead *.rake,*.mab set ft=ruby
au BufNewFile,BufRead *.erb set ft=eruby

au BufNewFile,BufRead *.pjs set ft=php.javascript

" ruby - what tabs?
au FileType ruby,eruby setlocal ts=2 sw=2 tw=79 et sts=2 autoindent colorcolumn=80
" and your yaml
au FileType yaml setlocal ts=2 sw=2 et colorcolumn=80

" source code gets wrapped at <80 and auto-indented
au FileType asm,c,cpp,javascript,php,html,make,objc,perl setlocal tw=79 autoindent colorcolumn=80

" makefiles and c have tabstops at 8 for portability
au FileType make,c,cpp,objc set ts=8 sw=8

" email - expand tabs, wrap at 68 for future quoting, enable spelling
au FileType mail setlocal tw=68 et spell spelllang=en_us colorcolumn=69

" commit messages are like email
au FileType cvs,gitcommit setlocal tw=68 et colorcolumn=69

" and make sure there's a blank line for me to start typing (openbsd's cvs does
" this by default)
au FileType cvs s/^CVS:/CVS:/|1


" macros

" control+d - delete the current line and all remaining text of an email up to
" the line of my signature (or the rest of the file) - useful for deleting lots
" of useless quoted text
function KillToSig()
  let curline = line(".")
  if search("^-- ") > 0
    exec curline
    normal! ^d/^-- /O
    exec curline
  else
    normal! dGo
  endif
endfunction
map  <C-o>:let curline=line(".")<C-o>:exec KillToSig()<C-o>:exec curline<CR>

" control+] toggles colorcolumn
let s:cc = ""
function ToggleColorColumn()
  let curline=line(".")
  if &colorcolumn
    let s:cc=&colorcolumn
    set colorcolumn=0
    echo s:cc
  else
    exec "set colorcolumn=" . s:cc
  end
  exec curline
endfunction
map  <Esc>:let curline=line(".")<CR>:exec ToggleColorColumn()<CR>:exec curline<CR>

" control+t - refresh
map  :syn sync ccomment cComment minlines=500<CR>

" make buffer windows easier to navigate
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-n> :bn<CR>
map <C-p> :bp<CR>
map <C-x> :bd<CR>

" me fail english?  that's unpossible!
abbr seperate separate
abbr furnature furniture
abbr rediculous ridiculous
abbr definetly definitely
abbr shold should
abbr appologize apologize
abbr propogate propagate
abbr eachother each other

" i hold shift a lot, make :W work like :w and :Q like :q
cabbr W w
cabbr Q q

" :w !sudo tee % 
