{
  description = "Convert Typst content to CommonMark";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    package-check.url = "github:typst/package-check/v0.6.0";
    package-check.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      package-check,
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs supportedSystems;
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      overlays.default = import ./overlay.nix;

      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
            (final: prev: {
              inherit (package-check.packages.${prev.stdenv.hostPlatform.system}) typst-package-check;
            })
          ];
        }
      );

      packages = forAllSystems (system: self.legacyPackages.${system}.typst2commonmark);

      checks = forAllSystems (
        system:
        let
          packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self.packages.${system};
          pkgTests = lib.concatMapAttrs (
            n: pkg:
            lib.mapAttrs' (c: checkPkg: lib.nameValuePair "package-${n}-tests-${c}" checkPkg) (
              pkg.passthru.tests or { }
            )
          ) self.packages.${system};
        in
        packages
        // pkgTests
        // {
          format = self.legacyPackages.${system}.runCommandLocal "format" { } ''
            ${lib.getExe self.formatter.${system}} --ci ${self}
            touch $out
          '';
        }
      );

      formatter = forAllSystems (system: self.legacyPackages.${system}.nixfmt-tree);
    };
}
