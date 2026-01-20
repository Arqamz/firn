{ config, lib, ... }:
let
  cfg = config.my.policy.cleanup;
in
{
  options.my.policy.cleanup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic garbage collection and store optimization";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.settings.auto-optimise-store = true;
  };
}
