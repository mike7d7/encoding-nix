{
  description = "F3kdb is a deband filter.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      deband-package =
        {
          lib,
          stdenv,
          cmake,
          pkg-config,
          vapoursynth,
          zimg,
          tbb,
        }:
        stdenv.mkDerivation {
          pname = "neo_f3kdb";
          version = "r9-git";
          src = pkgs.fetchFromGitHub {
            owner = "HomeOfAviSynthPlusEvolution";
            repo = "neo_f3kdb";
            rev = "ad9fa1a11412ab46199d3b8e7cc2e5a89f1d5d1a";
            hash = "sha256-bLBSO3x51A9RR7d21Z8S0vL4ZDALKO0epI+3WlTneKU=";
          };
          depsBuildBuild = [ pkg-config ];
          nativeBuildInputs = [
            cmake
            pkg-config
          ];
          buildInputs = [
            vapoursynth
            zimg
            tbb
          ];
          patches = [ ./cmake.patch ];
          installPhase = ''
            runHook preInstall

            install -D -t $out/lib/vapoursynth libneo-f3kdb.so

            runHook postInstall
          '';
        };

    in
    {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage deband-package { };
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      #
      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    };
}
