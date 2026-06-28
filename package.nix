{
  lib,
  stdenv,
  typst,
  jq,
  bashNonInteractive,
  runCommand,
  typst-package-check,
}:
let
  typstToml = lib.importTOML ./typst.toml;
in
stdenv.mkDerivation (finalAttrs: {
  pname = typstToml.package.name;
  inherit (typstToml.package) version;

  src = lib.cleanSourceWith {
    src = ./.;
    filter =
      path: _type:
      let
        name = baseNameOf path;
      in
      !(
        lib.hasSuffix ".nix" name
        || lib.elem name [
          ".envrc"
          "flake.lock"
          "CONTEXT.md"
          "docs"
        ]
      );
  };

  nativeBuildInputs = [
    typst
    jq
  ];

  doCheck = true;

  passthru.tests.typst-package-check =
    runCommand "typst-package-check"
      {
        nativeBuildInputs = [ typst-package-check ];
      }
      ''
        typst_toml=$(find ${finalAttrs.finalPackage} -name typst.toml -printf "%h")
        typst-package-check check --offline "$typst_toml"
        touch $out
      '';
})
