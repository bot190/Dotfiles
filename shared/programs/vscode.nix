{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "workbench.colorTheme" = "Solarized Dark";
        "editor.formatOnPaste" = true;
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.scrollBeyondLastLine" = false;
        "editor.formatOnSave" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontLigatures.enabled" = true;
        "window.openFoldersInNewWindow" = "on";
        "redhat.telemetry.enabled" = false;
      };
    };
  };

  # Additional packages to support VS Code
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixd
  ];
}
