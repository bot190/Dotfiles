{ config, pkgs, ... }:

{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jless
    jq
    xan
    hyperfine
    helm
    kubectl
    wl-clipboard
    git-agecrypt
    unzip
    uv
  ];

  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      daemon.enable = true;
      settings = {
        filter_mode_shell_up_key_binding = "session";

      };
    };

    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        gs = "git status";
        git-continue = "_git_continue";
      };

      bashrcExtra = ''
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

            if [ -d "$\{repo_path}/rebase-merge" ]; then
                git rebase --continue
            elif [ -d "$\{repo_path}/rebase-apply" ]; then
                git rebase --continue
            elif [ -f "$\{repo_path}/MERGE_HEAD" ]; then
                git merge --continue
            elif [ -f "$\{repo_path}/CHERRY_PICK_HEAD" ]; then
                git cherry-pick --continue
            elif [ -f "$\{repo_path}/REVERT_HEAD" ]; then
                git revert --continue
            else
                echo "No something in progress?"
            fi
        }
      '';
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      git = true;
      colors = "auto";
      icons = "auto";
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Ben Beauregard";
          email = "bot190@gmail.com";
        };
        alias = {
          branch-name = "!git rev-parse --abbrev-ref HEAD";
          update = "!git pull origin $(git branch-name)";
          fpush = "push --force";
          amend = "!git commit --amend --no-edit --date=now";

          cdiff = "git diff --cached";
          scommit = "commit -s";
        };
        init.defaultBranch = "main";
        push = {
          autoSetupRemote = true;
        };
      };

      signing = {
        format = "ssh";
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfRKKcEwIJw+SijhbGzBnGEv3YPRuORsOk06fkEiTgA";
        signer = "${pkgs.lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$time $sudo\\[$hostname:$directory\\] $git_branch$git_metrics$git_status$status$cmd_duration$character";
        cmd_duration.format = "[$duration](bold yellow)";
        directory.format = "[$path]($style)[$read_only]($read_only_style)";
        directory.truncate_to_repo = false;
        git_branch.format = "[$branch(:$remote_branch)]($style)";
        git_commit.disabled = true;
        git_metrics.format = "((\\([+$added]($added_style))(/[-$deleted]($deleted_style))\\))";
        git_metrics.disabled = false;
        git_status.format = "$ahead_behind$staged";
        hostname.ssh_symbol = "🌐";
        hostname.format = "[$ssh_symbol](bold blue)[$hostname]($style)";
        status.disabled = false;
        sudo.disabled = false;
        time.format = "[$time]($style)";
        time.style = "blue";
        time.disabled = false;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

}
