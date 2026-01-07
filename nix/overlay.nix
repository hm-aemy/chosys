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
            rev = "83fa0448107e31360393366ba4bef15a713ba5f4";
            hash = "sha256-FZ1h3p0NS3W/eqHgROvpOdib73qX+gsUGwGYJUA9uVg=";
            fetchSubmodules = true;
            leaveDotGit = true;
            inherit (previousAttrs.src) postFetch; # Preserve the postFetch script
          };
          patches = [
            (builtins.elemAt previousAttrs.patches 1)
          ];
          doCheck = false;
          makeFlags = previousAttrs.makeFlags ++ [
            "ENABLE_ABC=0"
          ];
        }
      );
}
