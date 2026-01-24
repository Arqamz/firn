{ lib, ... }:
{
  imports = lib.recursivelyImport {
    list = [ ./. ];
    exclude = [ ./default.nix ];
  };
}
