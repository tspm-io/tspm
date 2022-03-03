{ writeTextFile, runCommand, ... }: {
  manifest = grammars:
    runCommand "manifest.json" { } ''
      echo -n '${
        builtins.toJSON
        (builtins.map (g: builtins.removeAttrs g [ "src" ]) grammars)
      }' > $out
    '';

  mkGrammarPackage = grammar:
    let files = builtins.map (file: "${grammar.src}/${file}") grammar.files;
    in runCommand "tree-sitter-${grammar.name}-${grammar.author}" { } ''
      mkdir $out
      cp -r ${builtins.concatStringSep files " "} $out
    '';

  defaultFiles = [ "src" "LICENSE*" "license*" "NOTICE" "package.json" ];

  maintainers = import ./maintainers.nix;
}
