{ inputs }:
{
  # ============================================================================
  # mkSystem Helper
  # ============================================================================
  # A wrapper around nixpkgs.lib.nixosSystem to reduce boilerplate in flake.nix.
  # It automatically injects the inputs into specialArgs and imports the global module tree.
  mkSystem = { hostname, system, modules, specialArgs ? {} }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      
      # Pass flake inputs to all modules, allowing access to `inputs.*` anywhere in the config
      specialArgs = specialArgs // { inherit inputs; };
      
      modules = modules ++ [
        # Automatically set the networking hostname based on the mkSystem argument
        ({ ... }: { networking.hostName = hostname; })
        
        # Globally import the 'modules' directory tree (core, features, roles)
        # to ensure new config options (e.g., `my.features...`) are defined and available.
        ../modules
      ];
    };
}
