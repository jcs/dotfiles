" vim:ts=8
"
" vim 8 config
" joshua stein <jcs@jcs.org>
"

"
" defaults for everything
"
let c_minlines=500
set backspace=indent,eol,start
set hidden
set ignorecase
set incsearch
set laststatus=2
set modelines=5
set nocompatible
set nofoldenable
set nohlsearch
set nostartofline
set pastetoggle=<C-p>
set ruler
set scrolloff=10
set shiftwidth=4
set showcmd
set showmatch
set showmode
set smartcase
set smarttab
set spellfile=~/.vimspell.add
set spelllang=en_us
set tabstop=4
set timeoutlen=0
set wildmode=longest,list,full

" required for vundle
filetype off

" don't pollute directories with swap files, keep them in one place
silent !mkdir -p ~/.vim/{backup,swp}/
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
" except crontab, which will complain that it can't see any changes
au FileType crontab setlocal bkc=yes

"
" minor color config
"
set t_Co=256
syntax on
colorscheme jcs

"
" highlight stray spaces and tabs when out of insert mode
"
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
" performance hack
if version >= 702
  au BufWinLeave * call clearmatches()
endif

"
" try to detect xterm pasting to automatically disable autoindent and such
"
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

"
" when writing new files, mkdir -p their paths
"
augroup BWCCreateDir
    au!
    au BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

"
" init vim-plug (run "vim +PlugInstall +qall" after modifying)
"
" these require apostrophes instead of quotes for some dumb reason
call plug#begin()
Plug 'VundleVim/Vundle.vim'
Plug 'ap/vim-buftabline'
Plug 'ludovicchabant/vim-gutentags'
Plug 'cespare/vim-sbd'
Plug 'scrooloose/nerdtree'
call plug#end()

" disable plugin auto-indenting
filetype indent off
filetype plugin indent off

"
" make buffer windows easier to navigate
"
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" control+n and +p for next and previous buffers, but only in normal mode
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
" sbd plugin
nmap <C-x> :Sbd<CR>

" prevent those from running the nerdtree
autocmd FileType nerdtree noremap <buffer> <C-h> <nop>
autocmd FileType nerdtree noremap <buffer> <C-j> <nop>
autocmd FileType nerdtree noremap <buffer> <C-k> <nop>
autocmd FileType nerdtree noremap <buffer> <C-l> <nop>
autocmd FileType nerdtree noremap <buffer> <C-n> <nop>
autocmd FileType nerdtree noremap <buffer> <C-p> <nop>

"
" make < and > shifts retain selection
"
vnoremap < <gv
vnoremap > >gv

" disable annoying behavior where starting an auto-indented line with a hash
" makes it unindent and refuse to >>
:inoremap # X#

"
" per-file-type settings
"
" tell vim what kinds of files these are based on extension
au BufNewFile,BufRead *.phtml setlocal ft=php
au BufNewFile,BufRead *.rake,*.mab setlocal ft=ruby
au BufNewFile,BufRead *.erb setlocal ft=eruby
au BufNewFile,BufRead *.pjs setlocal ft=php.javascript
au BufRead,BufNewFile *.go setlocal ft=go
au BufNewFile,BufRead *.dsl setlocal ft=

" default to no color column
au FileType * setlocal colorcolumn=0

" all source code gets wrapped at <80 and auto-indented
au FileType arduino,asm,c,cpp,go,java,javascript,php,html,make,objc,perl setlocal tw=79 autoindent colorcolumn=81

" ruby has soft tabs
au FileType ruby,eruby setlocal ts=2 sw=2 tw=79 et sts=2 autoindent colorcolumn=81
au FileType yaml setlocal ts=2 sw=2 et colorcolumn=81

" makefiles and c have tabstops at 8 for portability
au FileType arduino,asm,make,c,cpp setlocal ts=8 sw=8

" email and commit messages - expand tabs, wrap at 68 for future quoting, enable spelling
au FileType cvs,gitcommit,mail setlocal tw=68 et spell colorcolumn=69

" and make sure cvs adds a blank line for me to start typing
" (openbsd's cvs does this by default)
au FileType cvs s/^CVS:/CVS:/|1

" and for email, work properly with format=flowed
au FileType mail setlocal formatoptions+=wq

" z80 assembler syntax file is outdated
au Syntax z8a syn match z8aPreProc "\.equ"
au Syntax z8a syn match z8aPreProc "\.gblequ"
au Syntax z8a syn match z8aPreProc "\.lclequ"


"
" package configuration
"

" gutentags
let g:gutentags_cache_dir="~/.vim/gutentags"
" use ectags
if filereadable("/usr/local/bin/ectags")
	let g:gutentags_ctags_executable="/usr/local/bin/ectags"
endif
let g:gutentags_ctags_executable_go="~/go/bin/gotags"
let g:gutentags_project_root=[ "CVS", ".gutentags_stop" ]
" i'll manually invoke :GutentagsUpdate when i need to
let g:gutentags_generate_on_missing=0
let g:gutentags_generate_on_new=0
let g:gutentags_generate_on_write=0

" nerdtree
let g:NERDTreeDirArrowExpandable="+"		 " use normal ascii
let g:NERDTreeDirArrowCollapsible="~"
let NERDTreeMinimalUI=1
" leave 80 chars for editing
let NERDTreeWinSize=str2nr(system('expr $COLUMNS - 81'))
let NERDTreeMapOpenRecursively="+"
let NERDTreeMapCloseChildren="-"		 " easier to remember
let NERDTreeIgnore = ['\.(o|pyc)$']

" only enable buftabline on multiple buffers
let g:buftabline_show=1

" nerdtree
let g:NERDTreeDirArrowExpandable="+"		" use normal ascii
let g:NERDTreeDirArrowCollapsible="~"
let NERDTreeMinimalUI=1
" leave 80 chars for editing
let NERDTreeWinSize=str2nr(system('expr $COLUMNS - 81'))
let NERDTreeMapOpenRecursively="+"
let NERDTreeMapCloseChildren="-"		" easier to remember
let NERDTreeIgnore = ['\.(o|pyc)$']

"
" macros
"

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

" a quick function to toggle color column on or off
let s:cc = ""
function ToggleColorColumn()
  if &colorcolumn
    let s:cc=&colorcolumn
    set colorcolumn=0
    echo s:cc
  else
    exec "set colorcolumn=" . s:cc
  end
endfunction
command! ToggleColorColumn :call ToggleColorColumn()

" i hold shift a lot, make :W work like :w and :Q like :q
cabbr W w
cabbr Q q
cabbr E e

" w! still failed?  try w!! to write as root
cmap w!! w !sudo tee >/dev/null %

" f will show the current function name
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>


"
" me fail english?  that's unpossible!
"
abbr seperate separate
abbr furnature furniture
abbr rediculous ridiculous
abbr definetly definitely
abbr shold should
abbr appologize apologize
abbr propogate propagate
abbr eachother each other


" when starting up, restore cursor position from viminfo
au BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" but git re-uses the same filename all the time, so ignore viminfo
au BufNewFile,BufRead *.git/* call setpos('.', [0, 1, 1, 0])
