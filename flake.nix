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
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      vs = pkgs.vapoursynth.withPlugins [
        pkgs.vapoursynth-bestsource
        vapoursynth-zip-flake.packages.x86_64-linux.default
        descale-flake.packages.x86_64-linux.default
        wnnm-flake.packages.x86_64-linux.default
        deband-flake.packages.x86_64-linux.default
        vs-jetpack-flake.packages.x86_64-linux.default
      ];
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
              vapoursynth
            ]
          ))
          vs
          pkgs.av1an
          pkgs.svt-av1-psy
          pkgs.mkvtoolnix-cli
          pkgs.opusTools
          grav1synth-flake.packages.x86_64-linux.default
          pkgs.vapoursynth-editor
        ];
      };
    };
}
