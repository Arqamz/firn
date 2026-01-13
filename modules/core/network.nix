{ lib, ... }:
{
  services.resolved.enable = true;
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  
  networking.firewall.enable = true;

  # Override with services.tailscale.enable = false; in host config if needed
  services.tailscale.enable = lib.mkDefault true;
  networking.firewall.checkReversePath = "loose";
}
