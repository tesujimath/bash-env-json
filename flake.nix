{
  description = "Nix package for bash-env-json";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          bash-env-json =
            let
              inherit (pkgs) bash coreutils gnused jq makeWrapper writeShellScriptBin;
              inherit (pkgs.lib) makeBinPath;

              substFullPaths = program_package:
                let replaceList = pkgs.lib.attrsets.mapAttrsToList (name: pkg: { from = " ${name} "; to = " ${pkg}/bin/${name} "; }) program_package; in
                builtins.replaceStrings (map (x: x.from) replaceList) (map (x: x.to) replaceList);

            in
            (writeShellScriptBin "bash-env-json"
              (substFullPaths
                {
                  env = pkgs.coreutils;
                  jq = pkgs.jq;
                  mktemp = pkgs.coreutils;
                  rm = pkgs.coreutils;
                  sed = pkgs.gnused;
                  touch = pkgs.coreutils;
                }
                (builtins.readFile ./bash-env-json))).overrideAttrs (old: {
              buildInputs = [ bash ];
              buildCommand =
                ''
                  ${old.buildCommand}
                  patchShebangs $out
                '';
            });
        in
        {
          devShells =
            let
              inherit (pkgs) bashInteractive bats mkShell;
              ci-packages =
                [
                  bats
                  bash-env-json
                ];
            in
            {
              default = mkShell { buildInputs = ci-packages ++ [ bashInteractive ]; };

              ci = mkShell { buildInputs = ci-packages; };

            };

          packages.default = bash-env-json;
        }
      );
}
