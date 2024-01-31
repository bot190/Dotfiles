# Git Aliases
alias gchk='git checkout'
#alias gl='git --no-pager log -n 2'
alias gs='git status'
alias gl='_gl'

## Allow calling with or without number of commits to show
function _gl {
    if [ -n "$1" ]; then
        git --no-pager log -n "$1"
    else
        git --no-pager log -n 2
    fi
}


_git_checkout ()
{
	__git_has_doubledash && return

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__gitcomp "
			--quiet --ours --theirs --track --no-track --merge
			--conflict= --orphan --patch --detach --ignore-skip-worktree-bits
			--recurse-submodules --no-recurse-submodules
			"
		;;
	*)
		# check if --track, --no-track, or --no-guess was specified
		# if so, disable DWIM mode
		local flags="--track --no-track --no-guess" track_opt="--track"
		if [ "$GIT_COMPLETION_CHECKOUT_NO_GUESS" = "1" ] ||
		   [ -n "$(__git_find_on_cmdline "$flags")" ]; then
			track_opt=''
		fi
                if [ "$command" = "checkoutr" ]; then
                    __git_complete_refs $track_opt
                else
                    __gitcomp_direct "$(__git_heads "" "$cur" " ")"
                fi
		;;
	esac
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
