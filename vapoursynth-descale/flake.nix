{
  description = "VapourSynth plugin to undo upscaling";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    descale-package = {
      lib,
      stdenv,
      meson,
      ninja,
      pkg-config,
      vapoursynth,
    }:
    stdenv.mkDerivation {
      pname = "descale";
      version = "r10-git";
      src = pkgs.fetchFromGitHub {
        owner = "Jaded-Encoding-Thaumaturgy";
        repo = "vapoursynth-descale";
        rev = "0e6fb3987ba5ad6b48d4d63fc4e5eff6e5633d06";
        hash = "sha256-T4Fl8U3DiXn/LSQOeS0W7f195EkpcfDfTPLvAtYdIlg=";
      };
      depsBuildBuild = [ pkg-config ];
      nativeBuildInputs = [
        meson
        ninja
        pkg-config
      ];
      buildInputs = [
        vapoursynth
      ];
      postPatch = ''
        substituteInPlace meson.build \
        --replace-fail "vs.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
      '';
    };

  in {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage descale-package {};
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    #
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
