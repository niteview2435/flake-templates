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
        $aux_dir = 'build';
        $out_dir = '.';
        $silent = 1;
        $lualatex = 'lualatex -interaction=batchmode -halt-on-error %O %S';
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
      mkCommand = pkgs.writeShellScriptBin "mk" ''
        latexmk -r "$PRJ_ROOT/.latexmkrc" "$@"
    '';
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          tex
          pkgs.texlab
          mkCommand
        ];
        shellHook = ''
          export PRJ_ROOT="$(pwd)"
          export TEXINPUTS=".:$PRJ_ROOT//:"
          ln -sf ${latexmkrc} .latexmkrc
        '';
      };
    };
}
