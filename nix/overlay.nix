final: prev: rec {
  clang-yosys =
    (final.pkgs.yosys.override {
      stdenv = final.pkgs.clangStdenv;
      enablePython = false;
      gtkwave = null;
    }).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          version = "0.51";
          src = prev.fetchFromGitHub {
            owner = "YosysHQ";
            repo = "yosys";
            rev = "f95de7d3403482194fe641126aa5046078853612";
            hash = "sha256-fBweo6n4Tb4mhO1NfvK/8vjxGfcEZZyGA7ITey9Bst0=";
            fetchSubmodules = true;
            leaveDotGit = true;
            inherit (previousAttrs.src) postFetch; # Preserve the postFetch script
          };
          doCheck = false;
          makeFlags = previousAttrs.makeFlags ++ [
            "ENABLE_ABC=0"
          ];
        }
      );
}
