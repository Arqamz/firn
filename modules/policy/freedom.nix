{ config, lib, ... }:
let
  cfg = config.my.policy.freedom;
in
{
  options.my.policy.freedom = {
    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow unfree software in nixpkgs";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = cfg.allowUnfree;
  };
}
