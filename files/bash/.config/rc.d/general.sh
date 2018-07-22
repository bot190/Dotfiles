# general aliases
alias ls='ls --color'
alias l='ls -lah'
alias tmux="tmux -2"

function dus {
    if [ -n "$1" ]; then
        du -hd "$1" | sort -h
    else
        du -hd 1 | sort -h
    fi
}

mkcdir () {
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}


