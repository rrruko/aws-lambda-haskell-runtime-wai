{
  description = "aws-lambda-haskell-runtime-wai";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in rec {
        packages.aws-lambda-haskell-runtime-wai =
          pkgs.haskellPackages.callCabal2nix "aws-lambda-haskell-runtime-wai" self rec {
          };
          devShell = pkgs.mkShell {
            buildInputs = with pkgs.haskellPackages; [
              ghcid
              cabal-install
              (pkgs.haskell.packages.ghc902.ghcWithPackages (p: [ p.zlib ]))
              pkgs.pkgconfig
            ];
        };
        packages.default = packages.aws-lambda-haskell-runtime-wai;
      });
}
