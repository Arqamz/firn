{ inputs }:
let
  recursivelyImport = import ./recursivelyImport.nix { lib = inputs.nixpkgs.lib; };
in
{
  # ============================================================================
  # mkSystem Helper
  # ============================================================================
  # A wrapper around nixpkgs.lib.nixosSystem to reduce boilerplate in flake.nix.
  # 
  # This function:
  #   1. Injects flake inputs into all modules via specialArgs
  #   2. Sets the hostname and stateVersion automatically
  #   3. Processes the `roles` list to enable corresponding role options
  #   4. Sets the platform identifier for CI/CD and assertions
  #   5. Imports the global module tree (core, features, roles)
  #   6. Automatically configures cross-compilation when needed
  #
  # Cross-compilation is automatically detected and configured:
  #   - If buildSystem != system, cross-compilation is enabled
  #   - Example: buildSystem = "x86_64-linux", system = "aarch64-linux"
  #   - This is transparent to host configurations
  #
  # Features and hardware are configured directly in host files, not here.
  # This keeps the drip-down logic minimal and avoids wrapper boilerplate.
  #
  # Usage in flake.nix:
  #   lib.mkSystem {
  #     hostname = "myhost";
  #     system = "x86_64-linux";
  #     platform = "nixos-linux";  # nixos-linux | nixos-wsl | nix-darwin
  #     roles = [ "interactive" "compute" ];
  #     modules = [ ./hosts/myhost ];
  #   }
  #
  # For cross-compilation:
  #   lib.mkSystem {
  #     hostname = "myhost";
  #     system = "aarch64-linux";        # Target system
  #     buildSystem = "x86_64-linux";    # Build system (optional, defaults to system)
  #     platform = "nixos-linux";
  #     roles = [ "server" ];
  #     modules = [ ./hosts/myhost ];
  #   }
  # ============================================================================
  mkSystem = { 
    hostname, 
    system, 
    platform,  # Required: "nixos-linux" | "nixos-wsl" | "nix-darwin"
    modules ? [], 
    roles ? [], 
    stateVersion ? "25.11",
    specialArgs ? {},
    buildSystem ? system  # Defaults to same as system (native build)
  }:
    let
      # Determine if we need cross-compilation
      isCrossCompiling = buildSystem != system;
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      
      # Pass flake inputs and platform to all modules
      # Also extend lib with project helpers (recursivelyImport)
      specialArgs = specialArgs // {
        inherit inputs platform;
        lib = inputs.nixpkgs.lib.extend (_: _: { inherit recursivelyImport; });
      };
      
      modules = [
        # ======================================================================
        # Agenix module for secret management
        # ======================================================================
        inputs.agenix.nixosModules.default

        # ======================================================================
        # Inline configuration module (the "drip-down" logic)
        # ======================================================================
        ({ lib, config, ... }: {
          # System identity
          networking.hostName = hostname;
          system.stateVersion = stateVersion;

          # ====================================================================
          # Cross-compilation configuration
          # ====================================================================
          # When cross-compiling, configure nixpkgs to use the build system
          # as the localSystem and the target system as crossSystem
          nixpkgs = lib.mkIf isCrossCompiling {
            buildPlatform = lib.systems.elaborate buildSystem;
            hostPlatform = lib.systems.elaborate system;
          };

          # ====================================================================
          # Roles: Enable based on the roles list
          # ====================================================================
          my.roles.interactive.enable = builtins.elem "interactive" roles;
          my.roles.mobile.enable = builtins.elem "mobile" roles;
          my.roles.compute.enable = builtins.elem "compute" roles;
          my.roles.server.enable = builtins.elem "server" roles;
        })
        
        # ======================================================================
        # Global module tree import
        # ======================================================================
        # Import the 'modules' directory tree (core, features, roles)
        # to ensure all config options (e.g., `my.features...`) are defined.
        ../modules
      ] ++ modules;
    };
}
