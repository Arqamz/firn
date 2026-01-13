{ config, lib, ... }:
let
  cfg = config.my.features.audio.pipewire;
in
{
  options.my.features.audio.pipewire.enable = lib.mkEnableOption "Pipewire Audio";

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
