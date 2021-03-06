#!/bin/bash

if [[ -p /dev/stdin ]]; then # stdin is a pipe
    p0=1
else
    p0=0
fi

if [[ -t 0 ]]; then          # stdin is a tty
    t0=1
else
    t0=0
fi

if [[ -t 1 ]]; then          # stdout is a tty
    t1=1
else
    t1=0
fi

_copy(){
    cat | xclip -selection clipboard
}

_paste(){
    xclip -selection clipboard -o
}

if [[ $p0 -eq 1 || $t0 -eq 0 ]]; then # stdin is pipe-ish
    _copy # so send it to the clipboard
    if [[ $t1 -eq 0 ]]; then # also, stdout is not a tty (meaning it must be a pipe or redirection)
        _paste # so pass that pipe/redirection the content of the clipboard (enables `man tee` like chaining)
    fi
else # stdin is not a pipe
    _paste # so output the clipboard
    if [[ $t1 -eq 1 ]]; then # stdout is a tty (so we don't have to be strict about not altering the output)
        echo # prevent the prompt from being on the same line
    fi
fi
