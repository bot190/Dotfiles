# Git Aliases
alias gchk='git checkout'
#alias gl='git --no-pager log -n 2'
alias gs='git status'

## Allow calling with or without number of commits to show
function gl {
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
