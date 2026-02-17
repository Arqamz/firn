{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.features.graphical.desktop.hyprland;
in
{
  options.my.features.graphical.desktop.hyprland.enable = lib.mkEnableOption "Hyprland Window Manager";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    # Graphical - Hyprland compositor
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    environment.systemPackages = with pkgs; [
      foot
      gpu-screen-recorder
      grim
      slurp
      swappy
      wl-clipboard
      cliphist
    ];

    # Wayland session variables for electron apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
