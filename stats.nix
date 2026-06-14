rec {

  config = {
    allowAliases = false;
  };

  pkgs = import ./. {
    inherit config;
  };

  inherit (pkgs) lib;

  attrpaths = import ./ci/eval/attrpaths.nix {
    inherit lib;
    extraNixpkgsConfigJson = lib.toJSON config;
  };

  all =
    lib.map
      (path: {
        inherit path;
        package = lib.getAttrFromPath path pkgs;
      })
      (
        lib.subtractLists [
          [
            "haskellPackages"
            "ghcup"
          ]
          [
            "vimPlugins"
            "rust-tools-nvim"
          ]
          [ "release-checks" ]
        ] attrpaths.paths
      );

  partition =
    property:
    lib.zipAttrs (
      lib.map (
        { path, package }:
        let
          result =
            if !(lib.hasAttr property package) then
              "unset"
            else if lib.getAttr property package then
              "true"
            else
              "false";
        in
        {
          ${result} = path;
        }
      ) all
    );

  partitioned = lib.listToAttrs (
    lib.map
      (name: {
        inherit name;
        value = partition name;
      })
      [
        "strictDeps"
        "__structuredAttrs"
        "enableParallelBuilding"
        "enableParallelChecking"
        "enableParallelInstalling"
      ]
  );

  stats = lib.mapAttrs (_: lib.mapAttrs (_: lib.length)) partitioned;
}
