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
          bash-env-json = import ./package.nix { inherit pkgs; };
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
