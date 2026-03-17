{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vapoursynth-zip-flake.url = "github:mike7d7/vapoursynth-zip";
    grav1synth-flake.url = "path:./grav1synth";
    descale-flake.url = "path:./vapoursynth-descale";
    wnnm-flake.url = "path:./vapoursynth-wnnm";
    deband-flake.url = "path:./vapoursynth-neo_f3kdb";
    vs-jetpack-flake.url = "path:./vapoursynth-vs-jetpack";
    vs-nlm-flake.url = "path:./vapoursynth-nlm-ispc";
    ffms2.url = "path:./vapoursynth-ffms2";
  };

  outputs =
    {
      self,
      nixpkgs,
      vapoursynth-zip-flake,
      grav1synth-flake,
      descale-flake,
      wnnm-flake,
      deband-flake,
      vs-jetpack-flake,
      vs-nlm-flake,
      ffms2,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      vs = pkgs.vapoursynth.withPlugins [
        pkgs.vapoursynth-bestsource
        pkgs.ffms
        vapoursynth-zip-flake.packages.x86_64-linux.default
        # descale-flake.packages.x86_64-linux.default
        # wnnm-flake.packages.x86_64-linux.default
        # deband-flake.packages.x86_64-linux.default
        vs-jetpack-flake.packages.x86_64-linux.default
        # vs-nlm-flake.packages.x86_64-linux.default
      ];
      av1an_u_5 = pkgs.av1an-unwrapped.overrideAttrs (rec {
        version = "0.5.2";
        src = pkgs.fetchFromGitHub {
          owner = "rust-av";
          repo = "Av1an";
          rev = "v0.5.2";
          hash = "sha256-JwYnDl9ZSSE+dD+ZAxuN7ywqFN314Ib/9Flh52kL3do=";
        };
        doCheck = false;
        patches = [ ];
        cargoPatches = [ ];
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-mxWYXujwp7tYAj9bM/ZhqbyISMjvX+AYG07otcB67pg=";
        };
      });
      svt_4 = pkgs.svt-av1.overrideAttrs (old: {
        version = "4.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "nekotrix";
          repo = "SVT-AV1-Essential";
          rev = "50bf4a650eba2c20dcdbba9ad5c3884a7c720208";
          hash = "sha256-85ItmD9HXQWf+QpVW5sqR5yn1vPMxhr7Oltwgx1Rlis=";
        };
        # src = pkgs.fetchFromGitLab {
        #   owner = "AOMediaCodec";
        #   repo = "SVT-AV1";
        #   rev = "v4.0.1";
        #   hash = "sha256-7krVkLZxgolqPTkuyKAx07BekAPacftcGZ44lQTQFZQ=";
        # };
      });
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.ffmpeg
          (pkgs.python3.withPackages (
            pypkgs: with pypkgs; [
              pymediainfo
              numpy
              tqdm
              beautifulsoup4
              vs
              psutil
            ]
          ))
          vs
          (pkgs.av1an.override {
            av1an-unwrapped = av1an_u_5;
            vapoursynth = vs;
          })
          svt_4
          pkgs.mkvtoolnix-cli
          # pkgs.opusTools # Temporal build failure
          # grav1synth-flake.packages.x86_64-linux.default
          # pkgs.vapoursynth-editor
        ];
        shellHook = ''
          echo "vapoursynth path = ${pkgs.lib.makeLibraryPath [ vs ]}"
          export VAPOURSYNTH_PLUGIN_PATH="${vs}/lib/vapoursynth"
        '';
      };
    };
}
