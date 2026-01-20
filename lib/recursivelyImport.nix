{ lib }:
let
  inherit (lib) hasSuffix;
  inherit (builtins) concatMap filter isList isPath readFileType;

  expandIfFolder = elem:
    if !isPath elem || readFileType elem != "directory"
      then [ elem ]
    else lib.filesystem.listFilesRecursive elem;

  toStr = elem: if isPath elem then toString elem else "";

  collect = { list, exclude ? [] }:
    let
      excludeStrs = builtins.map toString exclude;
    in
      filter
        (elem:
          (!isPath elem || hasSuffix ".nix" (toString elem))
          && !(isPath elem && builtins.elem (toString elem) excludeStrs)
        )
        (concatMap expandIfFolder list);
in
arg:
  if isList arg then collect { list = arg; } else collect arg
