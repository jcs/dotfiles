" vim:sw=8:ts=8
"
" act like t_Co=0 but use (256) color on just a few things
"

set background=light

hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "jcs"

hi SpecialKey		cterm=bold		ctermfg=NONE
hi NonText		cterm=bold		ctermfg=NONE
hi Directory		cterm=bold		ctermfg=NONE
hi IncSearch		cterm=reverse		ctermfg=NONE
hi Search		cterm=reverse		ctermfg=NONE
hi MoreMsg		cterm=bold		ctermfg=NONE
hi ModeMsg		cterm=bold		ctermfg=NONE
hi LineNr		cterm=NONE		ctermfg=250
hi Question		cterm=standout		ctermfg=NONE
hi StatusLine		cterm=bold,reverse	ctermfg=NONE
hi StatusLineNC		cterm=reverse		ctermfg=NONE
hi VertSplit		cterm=reverse		ctermfg=NONE
hi Title		cterm=bold		ctermfg=NONE
hi Visual		cterm=reverse		ctermfg=NONE
hi VisualNOS		cterm=bold,underline	ctermfg=NONE
hi WarningMsg		cterm=standout		ctermfg=NONE
hi WildMenu		cterm=standout		ctermfg=NONE
hi Folded		cterm=standout		ctermfg=NONE
hi FoldColumn		cterm=standout		ctermfg=NONE
hi DiffAdd		cterm=bold		ctermfg=NONE
hi DiffChange		cterm=bold		ctermfg=NONE
hi DiffDelete		cterm=bold		ctermfg=NONE
hi DiffText		cterm=reverse		ctermfg=NONE
hi Comment		cterm=NONE		ctermfg=242
hi Constant		cterm=underline		ctermfg=NONE
hi Special		cterm=bold		ctermfg=NONE
hi Identifier		cterm=underline		ctermfg=NONE
hi Statement		cterm=bold		ctermfg=NONE
hi PreProc		cterm=underline		ctermfg=NONE
hi Type			cterm=bold		ctermfg=NONE
hi Underlined		cterm=underline		ctermfg=NONE
hi Ignore		cterm=bold		ctermfg=NONE
hi ErrorMsg		cterm=reverse		ctermfg=9	ctermbg=15
hi Error		cterm=reverse		ctermfg=9	ctermbg=15
hi Todo			cterm=bold,standout	ctermfg=11	ctermbg=0
hi MatchParen		cterm=bold		ctermfg=yellow	ctermbg=0
