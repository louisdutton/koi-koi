{
  description = "A Nix-flake-based Odin development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
      inputs = pkgs: with pkgs; [ odin ];
    in
    {
      defaultPackage = forEachSupportedSystem (
        { pkgs }:
        pkgs.stdenv.mkDerivation (finalAttrs: rec {
          name = "game";
          src = self;
          buildInputs = inputs pkgs;
          buildPhase = "odin build src -out=${name}";
          installPhase = "cp ${name} $out";
        })
      );
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = inputs pkgs ++ (with pkgs; [ lldb ]);
          };
        }
      );
    };
}
