{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCargoIntegration = {
      url = "github:yusdacra/nix-cargo-integration";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rustOverlay.follows = "rust-overlay";
    };
    treeSitterSource = {
      url = "https://github.com/tree-sitter/tree-sitter.git";
      type = "git";
      flake = false;
    };
  };
  outputs =
    inputs@{ flake-utils, nixpkgs, nixCargoIntegration, treeSitterSource, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) runCommand lib stdenv;
        tree-sitter = (pkgs.callPackage ./lib/tree-sitter.nix {
          inherit nixCargoIntegration treeSitterSource;
        }).defaultPackage.${system};
        tspm = pkgs.callPackage ./lib { inherit tree-sitter; };
        grammars = pkgs.callPackage ./grammars.nix { inherit tspm; };
        playground = tspm.buildPlayground grammars;
        playgroundApp = {
          type = "app";
          program = "${playground}/run.sh";
        };
      in {
        checks = {
          format = pkgs.runCommand "format-check" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**.nix
            touch $out
          '';
          grammarTests = tspm.buildAllGrammars grammars { format = "test"; };
        };
        packages = {
          wasm = tspm.buildAllGrammars grammars { format = "wasm"; };
          pg = playground;
          playground = playground;
          artifacts = tspm.buildAllGrammars grammars {
            format = "src.tar.gz";
            paths = "metadata";
          };
          tree-sitter = tree-sitter;
        };
        defaultPackage = tspm.buildAllGrammars grammars { format = "src"; };
        apps = {
          tree-sitter = {
            type = "app";
            program = "${tree-sitter}/bin/tree-sitter";
          };
          pg = playgroundApp;
          playground = playgroundApp;
        };
        defaultApp = playgroundApp;
        # hmm... could replace this with nix-devshell
        devShell =
          pkgs.mkShell { buildInputs = with pkgs; [ nixfmt tree-sitter ]; };
      });
}
