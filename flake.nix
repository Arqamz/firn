{
  # https://github.com/arqamz/firn
  description = "The heart of my ever evolving attempt at nixos";

  # ============================================================================
  # Inputs
  # ============================================================================
  # Sources for packages and external modules.
  inputs = {
    # Main package repository, following the rolling 'unstable' channel to always get latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Small channel for faster updates
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # NixOS on WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Quickshell based `pretty` desktop shell for Wayland.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      # Ensure noctalia uses the same version of nixpkgs as this flake to avoid verification issues or duplication
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dotfiles flake containing configuration files
    dotfiles = {
      url = "github:arqamz/dotfiles";
      flake = true;
    };
  };

  # ============================================================================
  # Outputs
  # ============================================================================
  # The resulting configurations and packages produced by this flake.
  outputs = { self, nixpkgs, ... }@inputs:
    let
      # Import custom library functions (e.g. mkSystem) passing inputs for access
      lib = import ./lib { inherit inputs; };
    in {
      # NixOS System Configurations
      # Accessible via `nixos-rebuild switch --flake .#platinum`
      nixosConfigurations = {
        platinum = lib.mkSystem {
          hostname = "platinum";
          system = "x86_64-linux";
          # Host-specific configuration modules
          modules = [ ./hosts/platinum ];
        };
        zinc = lib.mkSystem {
          hostname = "zinc";
          system = "x86_64-linux";
          modules = [ ./hosts/zinc ];
        };
      };
    };
}
