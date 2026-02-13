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

    # Hyprland Wayland compositor
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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

    # Agenix - age-encrypted secrets for NixOS
    agenix = {
      url = "github:ryantm/agenix";
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
        # Antimony - Laptop Workstation
        # ======================================================================
        # Secondary HP Pavilion 15 (i7-8550U, UHD 620 + 940MX, 512GB SSD)
        # used for mobile development, testing, and overflow workloads.
        antimony = lib.mkSystem {
          hostname = "antimony";
          system = "x86_64-linux";
          platform = "nixos-linux";
          stateVersion = "25.11";
          roles = [ "interactive" "mobile" ];
          modules = [ ./hosts/antimony ];
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

        # ======================================================================
        # Nickel - Simple Graphical VM
        # ======================================================================
        # A graphical VM host that is used for testing out new features.
        nickel = lib.mkSystem {
          hostname = "nickel";
          system = "x86_64-linux";
          platform = "nixos-linux";
          stateVersion = "25.11";
          roles = [ "interactive" ];
          modules = [ ./hosts/nickel ];
        };

        # ======================================================================
        # Boron - Raspberry Pi Zero 2W
        # ======================================================================
        # A headless Raspberry Pi Zero 2W for light hosting and stuff I throw at it.
        # Cross-compiled from x86_64-linux and deployed remotely via SSH.
        # Deploy with:
        # nixos-rebuild switch --flake .#boron --target-host boron --build-host localhost
        boron = lib.mkSystem {
          hostname = "boron";
          system = "aarch64-linux";
          buildSystem = "x86_64-linux";
          platform = "nixos-linux";
          stateVersion = "25.11";
          roles = [ "server" ];
          modules = [ ./hosts/boron ];
        };
      };

      # ========================================================================
      # Packages
      # ========================================================================
      # Expose SD images and other build artifacts as packages
      packages.x86_64-linux = {
        # Boron SD card image for Raspberry Pi Zero 2W
        # Build with: nix build .#boron-image
        boron-image = self.nixosConfigurations.boron.config.system.build.sdImage;
      };
    };
}
