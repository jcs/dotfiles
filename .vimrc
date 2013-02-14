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
syntax on					" enable syntax highlighting
colorscheme jcs					" and load my colors

" don't pollute directories with swap files, keep them in one place
silent !mkdir -p ~/.vim/{backup,swp}/
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

if &term =~ "xterm.*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te

    function XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction

    map <expr> <Esc>[200~ XTermPasteBegin("i")
    imap <expr> <Esc>[200~ XTermPasteBegin("")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
endif

" nerdtree customizations

let NERDTreeDirArrows=0				 " use normal ascii
let NERDTreeMinimalUI=1				 " and save space
let NERDTreeWinSize=30				 " my terminals are 111 chars
						 " wide, so open to leave 80
						 " for editing
let NERDTreeMapOpenRecursively="+"
let NERDTreeMapCloseChildren="-"		 " easier for me to remember


" file type-specific settings

autocmd FileType * setlocal colorcolumn=0

" .phtml are php files
au BufNewFile,BufRead *.phtml setlocal ft=php

" these are rubyish files
au BufNewFile,BufRead *.rake,*.mab setlocal ft=ruby
au BufNewFile,BufRead *.erb setlocal ft=eruby

au BufNewFile,BufRead *.pjs setlocal ft=php.javascript

au BufRead,BufNewFile *.go setlocal ft=go

" ruby - what tabs?
au FileType ruby,eruby setlocal ts=2 sw=2 tw=79 et sts=2 autoindent colorcolumn=80
" and your yaml
au FileType yaml setlocal ts=2 sw=2 et colorcolumn=80

" source code gets wrapped at <80 and auto-indented
au FileType asm,c,cpp,go,java,javascript,php,html,make,objc,perl setlocal tw=79 autoindent colorcolumn=80

" makefiles and c have tabstops at 8 for portability
au FileType make,c,cpp setlocal ts=8 sw=8

" email - expand tabs, wrap at 68 for future quoting, enable spelling
au FileType mail setlocal tw=68 et spell spelllang=en_us colorcolumn=69

" commit messages are like email
au FileType cvs,gitcommit setlocal tw=68 et colorcolumn=69

" and make sure there's a blank line for me to start typing (openbsd's cvs does
" this by default)
au FileType cvs s/^CVS:/CVS:/|1

" when writing new files, mkdir -p their paths
augroup BWCCreateDir
    au!
    autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END


" highlight stray spaces and tabs when out of insert mode
" match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
" performance hack
if version >= 702
  au BufWinLeave * call clearmatches()
endif


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
map  <Esc>:let curline=line(".")<CR>:exec KillToSig()<CR>:exec curline<CR>

" control+] toggles colorcolumn
" XXX: this is kind of buggy, no idea why
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
map  <Esc>:let curline=line(".")<CR><C-o>:exec ToggleColorColumn()<CR><C-o>:exec curline<CR>

" make buffer windows easier to navigate
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-n> :bn<CR>
map <C-p> :bp<CR>
" sbd plugin
map <C-x> :Sbd<CR>

" prevent those from running the nerdtree
autocmd FileType nerdtree noremap <buffer> <C-h> <nop>
autocmd FileType nerdtree noremap <buffer> <C-j> <nop>
autocmd FileType nerdtree noremap <buffer> <C-k> <nop>
autocmd FileType nerdtree noremap <buffer> <C-l> <nop>
autocmd FileType nerdtree noremap <buffer> <C-n> <nop>
autocmd FileType nerdtree noremap <buffer> <C-p> <nop>

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

" load pathogen for nerdtree and things
call pathogen#infect()
