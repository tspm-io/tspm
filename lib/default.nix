{ system, tree-sitter, nodejs, emscripten, httplz, nix, gnutar, stdenv, lib
, fetchurl, linkFarm, callPackage, writeTextFile, writeShellScript, runCommand
}: rec {
  maintainers = import ./maintainers.nix;

  # TODO:
  # - cd into subpath
  # - desired ABI
  # - npm dependencies / submodules
  grammar = grammar: language: author:
    { format, ... }:
    stdenv.mkDerivation rec {
      inherit system format tree-sitter language;
      pname = "grammar-${language}-${author}-${format}";
      version = grammar.version;
      src = grammar.src;

      languageConfigJson = ./language-config.json;
      buildInputs = [ tree-sitter nodejs emscripten gnutar ];
      builder = ./build-grammar.sh;
    };

  buildAllGrammars = grammars: opts:
    linkFarm "all-grammars" (grammarLinks grammars opts);

  formatGrammars = grammars:
    lib.lists.flatten (builtins.map (language:
      builtins.map (author: {
        inherit language author;
        builder = grammars.${language}.${author} language author;
      }) (builtins.attrNames grammars.${language}))
      (builtins.attrNames grammars));

  grammarLinks = grammars: opts:
    let
      grammarToPath =
        if (opts.paths or "") == "metadata" then pathWithMetadata else path;
    in builtins.map (grammarToPath opts) grammars;

  path = opts: grammar: {
    name = "${grammar.language}/${grammar.author}";
    path = grammar.builder opts;
  };

  pathWithMetadata = opts: grammar:
    let
      artifact = grammar.builder opts;
      hash = builtins.hashFile "sha256" artifact;
      slug =
        "${grammar.language}/${grammar.author}/${artifact.version}-${hash}-${opts.format}";
    in {
      name = slug;
      path = artifact;
    };

  treeSitterJs = fetchurl {
    url =
      "https://github.com/tree-sitter/tree-sitter/releases/download/v${tree-sitter.version}/tree-sitter.js";
    sha256 = "sha256-M2eDcW3OdYSq9H0ldF8YwL4IAAQzmy+Fif2y0P32mV8=";
  };

  treeSitterWasm = fetchurl {
    url =
      "https://github.com/tree-sitter/tree-sitter/releases/download/v${tree-sitter.version}/tree-sitter.wasm";
    sha256 = "sha256-QBVbxeMq3KdHwApTeYZszBP2Q7de8lL7eT8AviFbcbk=";
  };

  copyFarm = name: entries:
    let
      copyEntry = { name, path }: ''
        mkdir -p "$(dirname ${name})"
        cp -r ${path} ${name}
      '';
      copies = builtins.map copyEntry entries;
    in runCommand name {
      preferLocalBuild = true;
      allowSubstitutes = false;
    } ''
      mkdir -p $out
      cd $out
      ${builtins.concatStringsSep "" copies}
    '';

  buildPlayground = grammars:
    let
      playgroundHtml = writeTextFile {
        name = "tree-sitter-playground-html";
        text = callPackage ./assets/index.html.nix { inherit grammars; };
      };
      entries = [
        {
          name = "run.sh";
          path = writeShellScript "tree-sitter-playground-run" ''
            ${httplz}/bin/httplz "$(dirname $0)"
          '';
        }
        {
          name = "tree-sitter.js";
          path = treeSitterJs;
        }
        {
          name = "tree-sitter.wasm";
          path = treeSitterWasm;
        }
        {
          name = "playground.js";
          path = ./assets/playground.js;
        }
        {
          name = "index.html";
          path = playgroundHtml;
        }
      ] ++ (grammarLinks grammars { format = "wasm"; });
    in copyFarm "tree-sitter-playground" entries;
}
