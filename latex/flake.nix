{
  description = "LuaLaTeX environment with custom class";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      latexmkrc = pkgs.writeText "latexmkrc" ''
        $lualatex = 'lualatex -interaction=nonstopmode -halt-on-error %O %S';
        $pdf_mode = 4;
        $postscript_mode = $dvi_mode = 0;
        $max_repeat = 5;
      '';
      tex = pkgs.texlive.withPackages (tpkgs: with tpkgs; [
        scheme-small
        luatexja
        latexmk
        collection-langjapanese
        geometry
        xcolor
        titlesec
        enumitem
        tools
        amsmath
        amsfonts
        physics
        physics2
        pgf
        pdfcol
        graphics
        tcolorbox
        tikzfill
        environ
        varwidth
        hyperref
      ]);
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          tex
          pkgs.texlab
        ];
        shellHook = ''
          export PRJ_ROOT="$(pwd)"
          export TEXINPUTS=".:$PRJ_ROOT//:"
          ln -sf ${latexmkrc} .latexmkrc
          alias mk='latexmk'
        '';
      };
    };
}
