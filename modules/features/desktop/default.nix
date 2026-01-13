{ config, lib, ... }:
{
  imports = [
    ./gnome.nix
    ./niri.nix
  ];

  config = {
    assertions = [
      {
        assertion = !(config.my.features.desktop.gnome.enable && config.my.features.desktop.niri.enable);
        message = "Cannot enable both Gnome and Niri Simultaneously. Please enable only one desktop environment.";
      }
    ];
  };
}
