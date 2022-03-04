{ bash, runCommand, system, tree-sitter, nodejs, emscripten, stdenv, lib
}: rec {
  maintainers = import ./maintainers.nix;

  # TODO:
  # - cd into subpath
  # - curry in desired ABI
  grammar = grammar: language: author:
    { format, ... }:
    stdenv.mkDerivation rec {
      inherit system format tree-sitter language;
      pname = "grammar-${language}-${author}-${format}";
      version = grammar.version;
      src = grammar.src;

      languageConfigJson = ./language-config.json;
      buildInputs = [ tree-sitter nodejs emscripten ];
      builder = ./build-grammar.sh;
    };

  buildAllGrammars = grammars: opts:
    let
      grammarLinks = builtins.map (grammar: ''
        mkdir -p $out/${grammar.language}
        ln -s ${grammar.builder opts} $out/${grammar.language}/${grammar.author}
      '') grammars;
    in runCommand "consolidate-all-grammars" { }
    (builtins.concatStringsSep "\n" grammarLinks);

  formatGrammars = grammars:
    lib.lists.flatten (builtins.map (language:
      builtins.map (author: {
        inherit language author;
        builder = grammars.${language}.${author} language author;
      }) (builtins.attrNames grammars.${language}))
      (builtins.attrNames grammars));
}
