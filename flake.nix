{
  description = "Nix package for bash-env-json";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      perSystem = system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          bash-env-json = import ./package.nix pkgs;
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
        };

      systemOutputs = forAllSystems perSystem;
    in
    {
      packages = forAllSystems (system: systemOutputs.${system}.packages);
      devShells = forAllSystems (system: systemOutputs.${system}.devShells);
    };
}
