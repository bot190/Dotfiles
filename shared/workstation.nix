{ config, pkgs, ... }:

{

  # Automount Manager
  # Requires `services.udisks2` to be enabled
  services.udiskie.enable = true;

  programs = {
    alacritty = {
      enable = true;
      theme = "solarized_dark";
      settings = {
        font = {
          size = 11;
          normal.family = "FiraCode Nerd Font";
        };
        window = {
          padding = {
            x = 5;
            y = 5;
          };
          decorations = "None";
        };

        mouse = {
          bindings = [
            {
              mouse = "Right";
              mods = "Control";
              action = "Paste";
            }
          ];
        };
      };
    };
  };
}
