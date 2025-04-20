{
  description = "Non-local means denoise filter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      descale-package =
        {
          lib,
          stdenv,
          cmake,
          pkg-config,
          vapoursynth,
          ispc,
        }:
        stdenv.mkDerivation {
          pname = "vs-nlm-ispc";
          version = "v2-git";
          src = pkgs.fetchFromGitHub {
            owner = "AmusementClub";
            repo = "vs-nlm-ispc";
            rev = "9580d1a98ee17ffbbbd85dfa14f6edefcbb5f262";
            hash = "sha256-c59zyFtoSsceznVw6tmfa3IGA4nHj6ErHZQt9YFdrXE=";
          };
          depsBuildBuild = [ pkg-config ];
          nativeBuildInputs = [
            pkg-config
            cmake
          ];
          buildInputs = [
            vapoursynth
            ispc
          ];
          installPhase = ''
            runHook preInstall

            install -D -t $out/lib/vapoursynth libvsnlm_ispc.so

            runHook postInstall
          '';
        };

    in
    {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage descale-package { };
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      #
      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    };
}
