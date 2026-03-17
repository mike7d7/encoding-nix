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
        jetpytools = pkgs.python3Packages.buildPythonPackage {
          pyproject = true;
          build-system = [ pkgs.python3Packages.setuptools ];
          pname = "jetpytools";
          version = "2.2.5";
          doCheck = false;
          propagatedBuildInputs = with pkgs.python3Packages; [
            setuptools
            flake8
            mypy
            mypy-extensions
            typing-extensions
            hatchling
            versioningit
          ];
          src = pkgs.fetchFromGitHub {
            owner = "Jaded-Encoding-Thaumaturgy";
            repo = "jetpytools";
            rev = "v${jetpytools.version}";
            hash = "sha256-t7VsMwLuMpnZkPy7TEor2KCj1eYdWTuW/4kHGsARL9g=";
          };
        };

        vsjetpack = pkgs.python3Packages.buildPythonPackage {
          pyproject = true;
          build-system = [ pkgs.python3Packages.setuptools ];
          pname = "vsjetpack";
          version = "1.1.0";

          postPatch = ''
            substituteInPlace pyproject.toml \
              --replace-fail "jetpytools~=2.2.1" "jetpytools"
          '';
          src = pkgs.fetchFromGitHub {
            owner = "Jaded-Encoding-Thaumaturgy";
            repo = "vs-jetpack";
            rev = "v${vsjetpack.version}";
            hash = "sha256-RoyeFWP7qV6hBehpofgHUMidPTFKZcMqyRYVoe8MvYg=";
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
