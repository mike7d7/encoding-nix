{
  description = "Weighted Nuclear Norm Minimization Denoiser for VapourSynth.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      descale-package =
        {
          lib,
          stdenv,
          cmake,
          pkg-config,
          ninja,
          vapoursynth,
          zimg,
          mkl,
        }:
        stdenv.mkDerivation {
          pname = "wnnm";
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "WolframRhodium";
            repo = "VapourSynth-WNNM";
            rev = "6d476bdb0ab7d988b5c5823678b4cae0cdbbbb85";
            hash = "sha256-a7gLGzEiVL+Za3b6U4w0EbdSev0aGYGa8f5sCVQrA44=";
          };
          depsBuildBuild = [ pkg-config ];
          nativeBuildInputs = [
            pkg-config
            cmake
            ninja
            # TODO: add vector libraries to improve performance.
          ];
          buildInputs = [
            vapoursynth
            zimg
            mkl
          ];
          NIX_CXXFLAGS_COMPILE = "-Wall -mavx -mfma -ffast-math";
          cmakeFlags = [
            "-DMKL_THREADING=sequential"
            "-DMKL_INTERFACE=lp64"
          ];
          installPhase = ''
            runHook preInstall

            install -D -t $out/lib/vapoursynth libwnnm.so

            runHook postInstall
          '';
        };

    in
    {
      packages.x86_64-linux.default = pkgs.callPackage descale-package { };
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      #
      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    };
}
