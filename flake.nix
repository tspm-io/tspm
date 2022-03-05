{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        tree-sitter-overlay = (self: super: {
          tree-sitter = super.callPackage ./lib/tree-sitter.nix {
            inherit (super.darwin.apple_sdk.frameworks) Security;
          };
        });
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ tree-sitter-overlay ];
        };
        lib = pkgs.callPackage ./lib { };
        grammars = pkgs.callPackage ./grammars.nix { tspm = lib; };
        playground = lib.buildPlayground grammars;
      in {
        checks = {
          format = pkgs.runCommand "format-check" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**.nix
            touch $out
          '';
          tests = lib.buildAllGrammars grammars { format = "test"; };
        };
        packages = {
          wasm = lib.buildAllGrammars grammars { format = "wasm"; };
          pg = playground;
          playground = playground;
        };
        defaultPackage = lib.buildAllGrammars grammars { format = "src"; };
        # hmm... could replace this with nix-devshell
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixfmt pkgs.tree-sitter ];
        };
      });
}
