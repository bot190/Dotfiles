{ ... }:

{
  services.walker = {
    enable = true;
    systemd.enable = true;
    enableElephantIntegration = true;
  };
  
  services.elephant.enable = true;
}
