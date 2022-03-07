{ nixCargoIntegration, treeSitterSource, runCommand, lib, stdenv, darwin, which
, emscripten }:
nixCargoIntegration.lib.makeOutputs {
  root = runCommand "patch-tree-sitter-cli-Cargo.toml" { } ''
    cp --recursive --no-preserve=mode ${treeSitterSource} $out
    echo '
    [package.metadata.nix]
    build = true
    app = true
    ' >> $out/cli/Cargo.toml
  '';
  renameOutputs = { "tree-sitter-cli" = "tree-sitter"; };
  crateOverrides = common: _: {
    tree-sitter-cli = prev: {
      buildInputs = (prev.buildInputs or [ ]) ++ (lib.optionals stdenv.isDarwin
        [ darwin.apple_sdk.frameworks.Security ]);
      nativeBuildInputs = (prev.nativeBuildInputs or [ ])
        ++ [ which emscripten ];
      preBuild = ''
        ${prev.preBuild or ""}
        bash ./script/build-wasm --debug
      '';
      postInstall = ''
        ${prev.postInstall or ""}
        PREFIX=$out make install
      '';
    };
  };
}
