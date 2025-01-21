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


_git_continue ()
{
    repo_path=$(git rev-parse --git-dir)

    if [ $? -ne 0 ]; then
        exit $?
    fi

    if [ -d "${repo_path}/rebase-merge" ]; then
        git rebase --continue
    elif [ -d "${repo_path}/rebase-apply" ]; then
        git rebase --continue
    elif [ -f "${repo_path}/MERGE_HEAD" ]; then
        git merge --continue
    elif [ -f "${repo_path}/CHERRY_PICK_HEAD" ]; then
        git cherry-pick --continue
    elif [ -f "${repo_path}/REVERT_HEAD" ]; then
        git revert --continue
    else
        echo "No something in progress?"
    fi
}

alias git-continue='_git_continue'
