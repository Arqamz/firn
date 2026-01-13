{ config, lib, pkgs, ... }:
let
  cfg = config.my.features.desktop.niri;
in
{
  options.my.features.desktop.niri.enable = lib.mkEnableOption "Niri Window Manager";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    
    # dependencies/tools that will be used
    environment.systemPackages = with pkgs; [
      foot
      gpu-screen-recorder
      grim
      slurp
      swappy
      wl-clipboard
      cliphist
      tuigreet
      xwayland-satellite
    ];

    # Tuigreet and Greetd as display manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd niri-session --remember --remember-user-session";
          user = "greeter";
        };
      };
    };

    # Wayland session variables for electron apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
