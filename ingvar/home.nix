{ config, pkgs, ... }:

{

  imports = [
    ./niri.nix
    ../shared/terminal.nix
    ../shared/workstation.nix
    ../shared/programs/niri.nix
    ../shared/programs/vscode.nix
    ../shared/programs/waybar.nix
  ];

  gtk = {
    gtk3.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';
    gtk4.extraConfig = ''
      gtk-application-prefer-dark-theme=1
    '';
  };

  services.remmina.enable = true;

  home.stateVersion = "25.05";
}
