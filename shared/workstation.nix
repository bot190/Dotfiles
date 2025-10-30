{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    loupe
    clapper
    signal-desktop
    orca-slicer
  ];

  # Automount Manager
  # Requires `services.udisks2` to be enabled
  services.udiskie.enable = true;

  services.hypridle = {
    enable = true;
    # systemdTarget = "graphical-session.target";
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

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
    hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = false;
        };

        auth = {
          fingerprint = {
            enabled = true;
            ready_message = "Scan fingerprint to unlock";
            present_message = "Scanning...";
            retry_delay = 250; # in milliseconds
          };
        };

        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };

        background = {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
        };

        input-field = {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

          font_color = "rgb(143, 143, 143)";
          fade_on_empty = false;
          rounding = 15;

          font_family = "$font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";

          # uncomment to use a letter instead of a dot to indicate the typed password
          # dots_text_format = *
          # dots_size = 0.4
          dots_spacing = 0.3;

          # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
          # hide_input = true

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        # TIME
        label = [
          {
            monitor = "";
            text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
            font_size = 90;
            font_family = "$font";

            position = "-30, 0";
            halign = "right";
            valign = "top";
          }

          # DATE
          {
            monitor = "";
            text = "cmd[update:60000] date +'%A, %d %B %Y'"; # update every 60 seconds
            font_size = 25;
            font_family = "$font";

            position = "-30, -150";
            halign = "right";
            valign = "top";
          }

          {
            monitor = "";
            text = "$LAYOUT[en,ru]";
            font_size = 24;
            onclick = "hyprctl switchxkblayout all next";

            position = "250, -20";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
