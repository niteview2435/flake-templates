{
  description = "My nix flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      templates = {
        latex = {
          path = ./latex;
          description = "Latex environment with LuaLaTeX";
        };
        r = {
          path = ./r;
          description = "R environment";
        };
        ipynb = {
          path = ./ipynb;
          description = "IPython Notebook environment";
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nil
          pkgs.nixpkgs-fmt
        ];
      };
    };
}
