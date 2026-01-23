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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # OpenCode
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Antigravity Nix
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal dotfiles flake containing configuration files
    dotfiles = {
      url = "github:arqamz/dotfiles";
      flake = true;
    };
  };

  # ============================================================================
  # Outputs
  # ============================================================================
  # The resulting configurations and packages produced by this flake.
  #
  # Each host is defined declaratively with:
  #   - hostname: The network name for the machine
  #   - system: The target architecture (e.g., x86_64-linux)
  #   - platform: The base configuration type (e.g., nixos-linux, nixos-wsl)
  #   - stateVersion: The NixOS release for state compatibility
  #   - roles: High-level machine purposes (e.g., interactive, compute)
  #   - modules: Machine-specific configurations and hardware definitions
  #
  # This "drip-down" design means alot of the configuration can be abstracted here,
  # and host files only contain machine-specific features and overrides.
  # ============================================================================
  outputs = { self, nixpkgs, ... }@inputs:
    let
      # Import custom library functions (e.g. mkSystem) passing inputs for access
      lib = import ./lib { inherit inputs; };
    in {
      # NixOS System Configurations
      # Accessible via `nixos-rebuild switch --flake .#<hostname>`
      nixosConfigurations = {
        
        # ======================================================================
        # Platinum - Desktop Workstation
        # ======================================================================
        # My main desktop workstation used for development, VMs, and daily driving
        # Boasting an AMD Ryzen 7 7700 CPU, Nvidia RTX 5060 Ti GPU, and 64GB RAM.
        platinum = lib.mkSystem {
          hostname = "platinum";
          system = "x86_64-linux";
          platform = "nixos-linux";
          stateVersion = "25.11";
          roles = [ "interactive" "compute" ];
          modules = [ ./hosts/platinum ];
        };
        
        # ======================================================================
        # Zinc - WSL Instances
        # ======================================================================
        # https://github.com/nix-community/NixOS-WSL
        # A headless WSL environment for any development on Windows.
        zinc = lib.mkSystem {
          hostname = "zinc";
          system = "x86_64-linux";
          platform = "nixos-wsl";
          stateVersion = "25.05";
          roles = [ "interactive" ];
          modules = [ ./hosts/zinc ];
        };
      };
    };
}
