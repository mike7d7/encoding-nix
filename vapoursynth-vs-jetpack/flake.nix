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
            rev = "83d246265bfe64b0160bc3b3e86411cab682cf0b";
            hash = "sha256-Qx9aGBj5oxdI0KxtSJ2lgNXlkrbLTv98qgMgdXtFF/E=";
          };
        };

        vsjetpack = pkgs.python3Packages.buildPythonPackage rec {
          pname = "vsjetpack";
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "Jaded-Encoding-Thaumaturgy";
            repo = "vs-jetpack";
            rev = "f2c46acd3a81c57354d67595d9446c259372ee7f";
            hash = "sha256-OKSduSmg4x1PLA6WZ8aHlaDo0mC1K1aWxthZWNr4Ck4=";
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
