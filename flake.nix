{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vapoursynth-zip-flake.url = "github:mike7d7/vapoursynth-zip";
    grav1synth-flake.url = "path:./grav1synth";
  };

  outputs = { self, nixpkgs, vapoursynth-zip-flake, grav1synth-flake }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
        vapoursynth-zip-overridden = vapoursynth-zip-flake.packages.x86_64-linux.default.overrideAttrs (oldAttrs: {
      src = "${vapoursynth-zip-flake}";  # Replace with the desired path
    });
    vs = pkgs.vapoursynth.withPlugins [
          pkgs.vapoursynth-bestsource
          vapoursynth-zip-flake.packages.x86_64-linux.default
        ];
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        pkgs.ffmpeg
        (pkgs.python3.withPackages(pypkgs: with pypkgs; [
          pymediainfo
          numpy
          tqdm
          beautifulsoup4
        ]))
        vs
        pkgs.av1an
        pkgs.svt-av1-psy
        pkgs.mkvtoolnix-cli
        pkgs.libopusenc
        grav1synth-flake.packages.x86_64-linux.default
      ];
    };
  };
}
