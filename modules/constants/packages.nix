{ inputs, pkgs, ... }:
{
  _module.args.packageSets = {
    core = with pkgs; [ ripgrep fd jq htop tmux lsof ];

    net = with pkgs; [ ethtool mtr ];

    inspect = with pkgs; [ pciutils usbutils dmidecode lshw ];

    nix = with pkgs; [ nix-index nix-du nix-tree cachix ] ++ [ (inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default) ];

    ux = with pkgs; [ eza yazi microfetch ];
  };
}
