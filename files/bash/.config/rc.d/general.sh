# General Aliases and functions

## Function definitions, these may be used in aliases so they come first
function runIfExists {
    if command -v $1 >/dev/null 2>&1; then
        echo "$1"
    else
        echo "$2"
    fi
}

# Aliases

## Use exa if its available, fallback to LS otherwise
which_ls=`runIfExists exa "ls --color"`
alias ls="$which_ls"
alias l='ls -lah'


alias tmux="tmux -2"

