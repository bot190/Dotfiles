{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
    };

    settings.mainBar = {
      height = 30;
      spacing = 4;
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ];
      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "power-profiles-daemon"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "battery"
        "clock"
        "tray"
        "custom/power"
      ];
      reload_style_on_change = true;

      "niri/window" = {
        format = "{}";
        rewrite."(.*) — Mozilla Firefox" = "󰈹 $1";
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      tray.spacing = 10;
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory.format = "{}% ";
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      backlight = {
        format = "{percent}% {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "-{power:4.2f}W {capacity}% {icon}";
        format-full = "{capacity}% {icon}";
        format-charging = "+{power:4.2f}W {capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        tooltip-format = "{timeTo}\nHealth: {health}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{bandwidthUpBytes} {bandwidthDownBytes} {ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
      };
      "custom/power" = {
        format = "⏻ ";
        tooltip = false;
        menu = "on-click";
        menu-file = "$HOME/.config/waybar/power_menu.xml";
        menu-actions = {
          shutdown = "shutdown";
          reboot = "reboot";
          suspend = "systemctl suspend";
          hibernate = "systemctl hibernate";
        };
      };
    };

    style = builtins.readFile ./waybar.css;
  };

  xdg.configFile."waybar/power_menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkMenu" id="menu">
        <child><object class="GtkMenuItem" id="suspend"><property name="label">Suspend</property></object></child>
        <child><object class="GtkMenuItem" id="hibernate"><property name="label">Hibernate</property></object></child>
        <child><object class="GtkMenuItem" id="shutdown"><property name="label">Shutdown</property></object></child>
        <child><object class="GtkSeparatorMenuItem" id="delimiter1"/></child>
        <child><object class="GtkMenuItem" id="reboot"><property name="label">Reboot</property></object></child>
      </object>
    </interface>
  '';
}
