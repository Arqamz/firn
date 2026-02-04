# ==========================================================================
# Home WiFi Profiles (NetworkManager)
# ==========================================================================
# Uses an age-encrypted env file for SSIDs + PSKs and injects values
# into NetworkManager profiles via $VARS substitution.
{ config, lib, ... }:
let
  cfg = config.my.features.network.wifi.home;
in
{
  options.my.features.network.wifi.home = {
    enable = lib.mkEnableOption "Home WiFi NetworkManager profiles";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.networking.networkmanager.enable;
        message = "Home WiFi profiles require NetworkManager to be enabled.";
      }
    ];

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [ config.age.secrets.wifi-home-envsubst.path ];

      profiles = {
        home-2g = {
          connection = {
            id = "home-2g";
            type = "wifi";
            autoconnect = true;
            autoconnect-priority = 10;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_HOME_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_HOME_PSK";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };

        home-5g = {
          connection = {
            id = "home-5g";
            type = "wifi";
            autoconnect = true;
            autoconnect-priority = 20; # Prefer this SSID more
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_HOME2_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WIFI_HOME2_PSK";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };
  };
}
