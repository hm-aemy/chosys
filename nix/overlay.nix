final: prev: rec {
  clang-yosys =
    (final.pkgs.yosys.override {
      stdenv = final.pkgs.clangStdenv;
      enablePython = false;
      gtkwave = null;
    }).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          version = "0.57";
          src = prev.fetchFromGitHub {
            owner = "YosysHQ";
            repo = "yosys";
            rev = "8cd6ee65605104017d29ef102ee1552dba0d192a";
            hash = "sha256-4yO1dSryw1SbhM8F5bxQiXxdbDaShrFp96elC3VqpRo=";
            fetchSubmodules = true;
            leaveDotGit = true;
            inherit (previousAttrs.src) postFetch; # Preserve the postFetch script
          };
          patches = [
            (builtins.elemAt previousAttrs.patches 1)
            (builtins.elemAt previousAttrs.patches 2)
          ];
          doCheck = false;
          makeFlags = previousAttrs.makeFlags ++ [
            "ENABLE_ABC=0"
          ];
        }
      );
}
