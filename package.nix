{ lib
, bash
, coreutils
, gnused
, jq
, writeShellScriptBin
, ...
}:
let
  substFullPaths = program_package:
    let replaceList = lib.attrsets.mapAttrsToList (name: pkg: { from = " ${name} "; to = " ${pkg}/bin/${name} "; }) program_package; in
    builtins.replaceStrings (map (x: x.from) replaceList) (map (x: x.to) replaceList);

in
(writeShellScriptBin "bash-env-json"
  (substFullPaths
    {
      env = coreutils;
      jq = jq;
      mktemp = coreutils;
      rm = coreutils;
      sed = gnused;
      touch = coreutils;
    }
    (builtins.readFile ./bash-env-json))).overrideAttrs (old: {
  buildInputs = [ bash ];
  buildCommand =
    ''
      ${old.buildCommand}
      patchShebangs $out
    '';
})
