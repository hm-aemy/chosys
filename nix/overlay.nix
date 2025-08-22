final: prev: rec {
  clang-yosys =
    (final.pkgs.yosys.override {
      stdenv = final.pkgs.clangStdenv;
      enablePython = false;
      gtkwave = null;
    }).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          version = "0.55";
          src = prev.fetchFromGitHub {
            owner = "YosysHQ";
            repo = "yosys";
            tag = "v${finalAttrs.version}";
            hash = "sha256-GddNbAtH5SPm7KTa5kCm/vGq4xOczx+jCnOSQl55gUI=";
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
