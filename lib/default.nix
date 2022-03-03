{ writeTextFile, runCommand, ... }:
{
  manifest = grammars:
    writeTextFile rec {
      name = "manifest.json";
      destination = name;
      text = builtins.toJSON (builtins.map (g: builtins.removeAttr g [ "src" ]) grammars);
    };

  mkGrammarPackage =
    grammar:
    let files = builtins.map (file: "${grammar.src}/${file}") grammar.files;
    in
    runCommand "tree-sitter-${grammar.name}-${grammar.author}" { } ''
      mkdir $out
      cp -r ${builtins.concatStringSep files " "} $out
    '';

  defaultFiles = [ "src" "LICENSE*" "license*" "NOTICE" "package.json" ];

  maintainers = import ./maintainers.nix;
}
