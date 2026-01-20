{ config, lib, ... }:
let
  cfg = config.my.policy.security;
in
{
  options.my.policy.security = {
    allowPasswordlessSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow passwordless sudo for wheel users";
    };
  };

  config = lib.mkIf cfg.allowPasswordlessSudo {
    my.features.security.passwordlessSudo = true;
  };
}
