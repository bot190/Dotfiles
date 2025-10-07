# This file manages all GUI software that I use on my machine

{
  config,
  lib,
  pkgs,
  ...
}:

{

  # Configure Gnome Display Manager to start Niri
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  services.gvfs.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "1password-gui"
      "vscode"
    ];

  # Enable packages that have special modules
  programs.niri.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ben" ];
  };

  programs.hyprlock.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable additional packages
  environment.systemPackages = with pkgs; [
    brightnessctl
    alacritty
    walker
    libqalculate
    mako
    hyprpolkitagent
    nautilus
    overskride
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    font-awesome
  ];
}
