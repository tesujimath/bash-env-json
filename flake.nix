{
  description = "Nix package for bash-env";

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
            in
            (writeShellScriptBin "bash-env-json" (builtins.readFile ./bash-env-json)).overrideAttrs (old: {
              buildInputs = [ bash jq makeWrapper ];
              buildCommand =
                ''
                  ${old.buildCommand}
                  patchShebangs $out
                  wrapProgram $out/bin/bash-env-json --prefix PATH : ${makeBinPath [
                    coreutils
                    gnused
                    jq
                  ]}
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
