{
  agent-of-empires,
  config,
  llm-agents,
  pkgs,
  ...
}:

{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/ingvar.yaml;
    secrets.atuin-sync-address = { };
    templates."atuin.env".content = ''
      ATUIN_SYNC_ADDRESS=${config.sops.placeholder.atuin-sync-address}
    '';
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jless
    jq
    xan
    hyperfine
    kubectl
    kubectl-rook-ceph
    kubernetes-helm
    fluxcd
    wl-clipboard
    git-agecrypt
    unzip
    uv
    sops
    go-task
    agent-of-empires.packages.${pkgs.stdenv.hostPlatform.system}.aoe-with-web
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex-acp
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codegraph
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.openspec
  ];

  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      daemon.enable = true;
      settings = {
        filter_mode_shell_up_key_binding = "session";
        sync_frequency = "10m";
        auto_sync = true;
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = {
        gs = "git status";
        git-continue = "_git_continue";
        l = "ls -lah";
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

    tmux = {
      baseIndex = 1;
      enable = true;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      terminal = "screen-256color";

      extraConfig = ''
        # Split panes while preserving the current working directory.
        bind | split-window -h -c '#{pane_current_path}'
        bind - split-window -v -c '#{pane_current_path}'
        unbind '"'
        unbind %

        # Switch panes with Alt-arrow without the prefix.
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Reload the Home Manager generated configuration with <prefix>-r.
        bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

        # Save the current pane's history to a prompted filename.
        bind-key P command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -; save-buffer %1 ; delete-buffer'

        # Window status.
        set -g status-bg black
        set -g status-fg white
        set-option -g status-justify centre
        set-option -g status-left '#{prefix_highlight}#[fg=green,bg=black][#[bg=black,fg=cyan]#S#[fg=green]] #[fg=white]#T'
        set-option -g status-left-length 20

        setw -g automatic-rename on
        set-window-option -g window-status-format '#[fg=cyan,dim]#I#[fg=blue]:#[default]#W#[fg=grey,dim]#F'
        set-window-option -g window-status-current-format '#[bg=black,fg=cyan,bold]#I#[bg=black,fg=cyan]:#[fg=blue]#W#[fg=dim]#F'

        set -g status-right '#[fg=green][#[fg=white]#{network_bandwidth}#[fg=green]] #[fg=green][#{cpu_fg_color}#{cpu_percentage}#[fg=green]] #{battery_status_bg}Batt:#{battery_percentage} #{battery_remain} #[fg=green] [#[fg=blue]%Y-%m-%d #[fg=blue]%H:%M#[fg=green]]'
        set -g status-right-length 150
        set -g @batt_remain_short 'true'

        set -g allow-rename off

        # Plugins from the reference configuration.
        set -g @plugin 'tmux-plugins/tmux-cpu'
        set -g @plugin 'jbnicolai/tmux-fpp'
        set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
        set -g @plugin 'tmux-plugins/tmux-sidebar'
        set -g @plugin 'odedlaz/tmux-status-variables'
        set -g @plugin 'tmux-plugins/tmux-resurrect'
        set -g @plugin 'tmux-plugins/tmux-battery'
        set -g @plugin 'xamut/tmux-network-bandwidth'

        set -g @resurrect-processes 'nmon'

        if "test ! -d ~/.config/tmux/plugins/tpm" \
          "run 'git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && ~/.config/tmux/plugins/tpm/bin/install_plugins'"

        # Initialize TPM last so it can discover every plugin declaration.
        run '~/.config/tmux/plugins/tpm/tpm'
      '';
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  systemd.user.services.atuin-daemon = {
    Service.EnvironmentFile = config.sops.templates."atuin.env".path;
  };

}
