" sbd.vim — Smart Buffer Delete
"
" :help sbd.txt

if exists('loaded_sbd')
    finish
endif
let loaded_sbd = 1

if !exists('g:sbd_delete_anyway')
    let g:sbd_delete_anyway = 0
endif

if !exists('g:sbd_close_special')
    let g:sbd_close_special = 1
endif

let s:modeNormal = 'n'
let s:modeCloseModified = 'm'

silent command! -nargs=0 Sbd    call <SID>DeleteBuffer(s:modeNormal)
silent command! -nargs=0 Sbdm   call <SID>DeleteBuffer(s:modeCloseModified)

function <SID>DeleteBuffer(mode)
    let s:sbdBuffer = bufnr("%")
    let s:sbdBufferCount = 0
    let s:sbdEmptyBuffer = 0
    let s:sbdWindow = winnr()

    if (a:mode != s:modeCloseModified
                \ && getbufvar(s:sbdBuffer, '&modified') == 1
                \ && g:sbd_delete_anyway == 0)
        echom "sbd: save your changes first."
        return
    endif

    for i in range(1, bufnr('$'))
        if (getbufvar(i, '&buflisted') == 1 && getbufvar(i, '&modifiable') == 1)
            let s:sbdBufferCount = s:sbdBufferCount + 1
        endif
    endfor

    windo call s:PreserveWindowLayout()

    if (getbufvar(s:sbdBuffer, '&buflisted') == 1)
        execute "bdelete! " . s:sbdBuffer. ""
    endif

    " switch to original window
    execute "normal! " . s:sbdWindow . "\<C-w>\<C-w>"
endfunction

function s:PreserveWindowLayout()
    if (s:sbdBuffer == bufnr("%"))
        let prevBuffer = bufnr("#")

        " we're dealing with a special buffer
        if (&buftype != "" && g:sbd_close_special == 1)
            close

        " switch to a convenient buffer
        elseif (s:sbdBufferCount <= 1 && s:sbdEmptyBuffer != 0)
            execute "buffer! " . s:sbdEmptyBuffer
        elseif (s:sbdBufferCount <= 1 && s:sbdEmptyBuffer == 0)
            enew!
            let s:sbdEmptyBuffer = bufnr('%')
        elseif (prevBuffer > 0 && buflisted(prevBuffer) && prevBuffer != s:sbdBuffer)
            buffer! #
        else
            bprevious!
        endif
    endif
endfunction
