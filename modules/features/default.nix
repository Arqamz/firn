{ ... }:
{
  imports = [
    ./hardware/nvidia.nix
    ./desktop
    ./services/pipewire.nix
    ./virtualisation/libvirtd.nix
    ./power
  ];
}
