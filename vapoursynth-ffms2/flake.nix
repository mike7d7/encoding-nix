{
  description = "VapourSynth plugin to undo upscaling";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      ffms2-package =
        {
          lib,
          stdenv,
          pkg-config,
          vapoursynth,
        }:
        stdenv.mkDerivation {
          pname = "ffms2";
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "FFMS";
            repo = "ffms2";
            rev = "adf56fb4c4ea751cd05d914959e9bee1a7776ac0";
            hash = "sha256-v2UNOAdOUeZIlCKbeY8gaG06eAkNb5McO9pG1/zcKmk=";
          };
          nativeBuildInputs = [
            pkg-config
            pkgs.autoconf
            pkgs.automake
          ];
          buildInputs = [
            vapoursynth
          ]
          ++ (with pkgs; [
            ffmpeg
            libtool
            zlib
            avisynthplus.dev
          ]);
          preConfigure = ''
            patchShebangs .
            ./autogen.sh

            # mkdir build
            # cd build
          '';
          # configureScript = "../configure";

          configureFlags = [
            "--enable-avisynth"
          ];

          # installPhase = ''
          #   runHook preInstall
          #   make install
          #   install -D -t $out/lib/vapoursynth lib/libffms2.so
          #
          #   runHook postInstall
          # '';

          postInstall = ''
            echo "Custom install logic"
            install -Dm755 $out/lib/libffms2.so.4.1.1 $out/lib/vapoursynth/libffms2.so
          '';
        };

    in
    {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ffms2-package { };
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      #
      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    };
}
