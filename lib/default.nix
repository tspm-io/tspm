{ bash, runCommand, system, tree-sitter, nodejs, stdenv, lib }: {
  maintainers = import ./maintainers.nix;

  # TODO:
  # - cd into subpath
  # - curry in desired ABI
  buildGrammar = grammar: language: author:
    { format, ... }:
    stdenv.mkDerivation rec {
      inherit system format tree-sitter language;
      pname = "grammar-${language}-${author}-${format}";
      version = grammar.revision;

      src = builtins.fetchGit {
        url = grammar.remote;
        rev = version;
        ref = if builtins.hasAttr "ref" grammar then grammar.ref else "master";
      };

      languageConfigJson = ./language-config.json;

      buildInputs = [ tree-sitter nodejs ];

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
