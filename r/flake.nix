{
  description = "R development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      rEnv = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          ggplot2
          dplyr
          languageserver
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          rEnv
        ];
      };
    };
}
