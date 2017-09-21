" vim:ts=8
"
" vim 8 config
" joshua stein <jcs@jcs.org>
"

" defaults for everything
let c_minlines=500
set backspace=indent,eol,start
set hidden
set ignorecase
set incsearch
set laststatus=2
set modelines=5
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
set spellfile=~/.vimspell.add
set spelllang=en_us
set tabstop=4
set wildmode=longest,list,full


" minor color config
set t_Co=256
syntax on
colorscheme jcs


" don't pollute directories with swap files, keep them in one place
silent !mkdir -p ~/.vim/{backup,swp}/
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" except crontab, which will complain that it can't see any changes
au FileType crontab setlocal bkc=yes


" try to detect xterm pasting to automatically disable autoindent and such
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
let g:NERDTreeDirArrowExpandable="+"		 " use normal ascii
let g:NERDTreeDirArrowCollapsible="~"		 " use normal ascii
let NERDTreeMinimalUI=1				 " and save space
let NERDTreeWinSize=20				 " leave 80 chars for editing
let NERDTreeMapOpenRecursively="+"
let NERDTreeMapCloseChildren="-"		 " easier for me to remember
let NERDTreeIgnore = ['\.(o|pyc)$']


" tell vim what kinds of files these are based on extension
au BufNewFile,BufRead *.phtml setlocal ft=php
au BufNewFile,BufRead *.rake,*.mab setlocal ft=ruby
au BufNewFile,BufRead *.erb setlocal ft=eruby
au BufNewFile,BufRead *.pjs setlocal ft=php.javascript
au BufRead,BufNewFile *.go setlocal ft=go

au BufNewFile,BufRead *.dsl setlocal ft=


" per-file-type settings
au FileType * setlocal colorcolumn=0

" all source code gets wrapped at <80 and auto-indented
au FileType asm,c,cpp,go,java,javascript,php,html,make,objc,perl setlocal tw=79 autoindent colorcolumn=80

" ruby has soft tabs
au FileType ruby,eruby setlocal ts=2 sw=2 tw=79 et sts=2 autoindent colorcolumn=80
au FileType yaml setlocal ts=2 sw=2 et colorcolumn=80

" makefiles and c have tabstops at 8 for portability
au FileType make,c,cpp setlocal ts=8 sw=8

" email and commit messages - expand tabs, wrap at 68 for future quoting, enable spelling
au FileType cvs,gitcommit,mail setlocal tw=68 et spell colorcolumn=69

" and make sure cvs adds a blank line for me to start typing
" (openbsd's cvs does this by default)
au FileType cvs s/^CVS:/CVS:/|1


" tell gutentags to use ectags
let g:gutentags_ctags_executable="/usr/local/bin/ectags"
let g:gutentags_ctags_executable_go="~/go/bin/gotags"
let g:gutentags_cache_dir="~/.vim/gutentags"
let g:gutentags_project_root=[ "CVS" ]
" i'll manually invoke :GutentagsUpdate when i need to
let g:gutentags_generate_on_missing=0
let g:gutentags_generate_on_new=0


" when writing new files, mkdir -p their paths
augroup BWCCreateDir
    au!
    au BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
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

" make buffer windows easier to navigate
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


" me fail english?  that's unpossible!
abbr seperate separate
abbr furnature furniture
abbr rediculous ridiculous
abbr definetly definitely
abbr shold should
abbr appologize apologize
abbr propogate propagate
abbr eachother each other

" stupid xiaomi keyboard
abbr NLL NULL

" i hold shift a lot, make :W work like :w and :Q like :q
cabbr W w
cabbr Q q

" TODO: make this an alias like :sudow
" :w !sudo tee % 

" disable annoying behavior where starting an auto-indented line with a hash
" makes it unindent and refuse to >>
:inoremap # X#

" load pathogen for nerdtree and things
call pathogen#infect()

" restore cursor position from viminfo
au BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" but git re-uses the same filename all the time, so ignore viminfo
au BufNewFile,BufRead *.git/* call setpos('.', [0, 1, 1, 0])
