# Git Aliases
alias gs='git status'

## Allow calling with or without number of commits to show
function gl {
    if [ -n "$1" ]; then
        git --no-pager log -n "$1"
    else
        git --no-pager log -n 2
    fi
}