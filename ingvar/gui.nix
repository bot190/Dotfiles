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
  };
  services.displayManager.gdm.enable = true;

  # Enable Gnome Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "1password-gui"
      "vscode"
    ];

  # Niri's package and configuration are managed by Home Manager. This module
  # remains enabled for its GDM session, portal, D-Bus, and systemd integration.
  programs.niri.enable = true;

  # Enable packages that have special modules
  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ben" ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable additional packages
  environment.systemPackages = with pkgs; [
    brightnessctl
    alacritty
    libqalculate
    mako
    hyprpolkitagent
    nautilus
    overskride
    gnome-keyring
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    font-awesome
  ];
}
