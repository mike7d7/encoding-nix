{
  description = "Full suite of filters, wrappers, and helper functions for filtering video using VapourSynth";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
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
            rev = "2be1b4e50377f8066fd58a77a71605d5d4be6059";
            hash = "sha256-DXqVQnlev5/UsbW+c3xkfWio9aEc17DNtf2v0y/bEho=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [
            numpy
            rich
            scipy
            typing-extensions
            vapoursynth
            jetpytools # Reference the local package
          ];
        };

        default = vsjetpack;
      };
    };
}
