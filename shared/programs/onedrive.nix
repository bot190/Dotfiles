{ pkgs, ... }:

{
  programs.onedrive = {
    enable = true;
    settings = {
    };
  };

  xdg.configFile."onedrive/sync_list".text = ''
    /Documents/PointyBrain/
  '';

  systemd.user.services.onedrive = {
    Unit = {
      Description = "OneDrive monitor";
      Wants = [ "network-online.target" ];
      After = [ "network-online.target" ];
    };

    Service = {
      ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
