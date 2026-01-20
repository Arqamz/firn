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
  # ============================================================================
  mkSystem = { 
    hostname, 
    system, 
    platform,  # Required: "nixos-linux" | "nixos-wsl" | "nix-darwin"
    modules ? [], 
    roles ? [], 
    stateVersion ? "25.11",
    specialArgs ? {} 
  }:
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
        # Inline configuration module (the "drip-down" logic)
        # ======================================================================
        ({ lib, ... }: {
          # System identity
          networking.hostName = hostname;
          system.stateVersion = stateVersion;

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
