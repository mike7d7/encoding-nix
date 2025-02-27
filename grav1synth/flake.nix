{
  description = "Grain Synth analyzer and editor for AV1 files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    grav1synth-package = {
      llvmPackages,
      clang,
      ffmpeg,
      pkg-config,
      rustPlatform,
    }:
    rustPlatform.buildRustPackage {
      pname = "grav1synth";
      version = "v0.1.0-beta.7-git";
      src = pkgs.fetchFromGitHub {
        owner = "rust-av";
        repo = "grav1synth";
        rev = "6965b42ecc06aa91ed4bdd9659dcc7785d3e23a9";
        hash = "sha256-082L1r9VSMIdM4LZaCDtlcFy4YGxg+JyVY8Mfcuc/TQ=";
      };
      cargoHash = "sha256-mDI3wa6XM4LKL5y0lTECLlEdH4h6KGYlDusmpwkrSns=";
      LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
      nativeBuildInputs = [
        clang
        pkg-config
      ];
      buildInputs = [
        ffmpeg
      ];
      doCheck = false;
      useFetchCargoVendor = true;
    };

  in {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage grav1synth-package {};
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    #
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
