{ config, pkgs, ... }:

{

  imports = [
    ../shared/terminal.nix
    ../shared/workstation.nix
    ../shared/programs/vscode.nix
  ];

  gtk = {
    gtk3.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';
    gtk4.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';
  };

  home.stateVersion = "25.05";
}
