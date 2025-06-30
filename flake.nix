{
  nixConfig.bash-prompt = "[nix(circt):\\w]$ ";
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        overlays = [(import ./nix/overlay.nix )];
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell.override{stdenv = pkgs.clangStdenv;} {
        packages = with pkgs; [
          clang-yosys
          lld
          llvm
          clang
          cmake
          ninja
        ];
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
          export PATH=$PWD/circt/build/bin:$PATH;
        '';
      };
    };
}
