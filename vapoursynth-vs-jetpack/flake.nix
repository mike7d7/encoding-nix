{
  description = "Full suite of filters, wrappers, and helper functions for filtering video using VapourSynth";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    vapoursynth-zip-flake.url = "github:mike7d7/vapoursynth-zip";
  };

  outputs =
    {
      self,
      nixpkgs,
      vapoursynth-zip-flake,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = rec {
        jetpytools = pkgs.python3Packages.buildPythonPackage rec {
          pname = "jetpytools";
          version = "git";
          doCheck = false;
          propagatedBuildInputs = with pkgs.python3Packages; [
            setuptools
            flake8
            mypy
            mypy-extensions
            typing-extensions
          ];
          src = pkgs.fetchFromGitHub {
            owner = "Jaded-Encoding-Thaumaturgy";
            repo = "jetpytools";
            rev = "691f91bda865ebc1eda92758908d538c1a6e15c8";
            hash = "sha256-9/M+rqPNQXzErDX8KaAfv9nyUWIiTYs2F+38fN6ZvAg=";
          };
        };

        vsjetpack = pkgs.python3Packages.buildPythonPackage rec {
          pname = "vsjetpack";
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "Jaded-Encoding-Thaumaturgy";
            repo = "vs-jetpack";
            rev = "f9aa99b18ebd0019c1d386c5868cfce3f43a1d6c";
            hash = "sha256-Y11dexbOXIKTZnSDgF2VqEwIRMtYg7IxlWI6nDSZPcw=";
          };
          propagatedBuildInputs = with pkgs; [
            vapoursynth
            vapoursynth-bestsource
            python3Packages.numpy
            python3Packages.rich
            python3Packages.scipy
            python3Packages.typing-extensions
            python3Packages.vapoursynth
            jetpytools # Reference the local package
            vapoursynth-zip-flake.packages.x86_64-linux.default
          ];
        };

        default = vsjetpack;
      };
    };
}
