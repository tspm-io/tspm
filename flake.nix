{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/release-21.11"; };
  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f system);
      pkgs' = (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        });
    in {
      overlays.default = final: prev: rec {
        tspm = final.callPackage ./lib { };
        grammars = final.callPackage ./grammars.nix { inherit tspm; };
        tree-sitter = final.callPackage ./lib/tree-sitter.nix {
          inherit (final.darwin.apple_sdk.frameworks) Security;
        };
      };

      checks = forAllSystems (system:
        let inherit (pkgs' system) runCommand nixfmt tspm grammars;
        in {
          format = runCommand "format-check" { } ''
            ${nixfmt}/bin/nixfmt --check ${./.}/**.nix
            touch $out
          '';
          tests = tspm.buildAllGrammars grammars { format = "test"; };
        });

      packages = forAllSystems (system:
        let
          pkgs = pkgs' system;
          inherit (pkgs) tspm grammars;
        in rec {
          src = tspm.buildAllGrammars grammars { format = "src"; };
          default = src;
          wasm = tspm.buildAllGrammars grammars { format = "wasm"; };
          playground = tspm.buildPlayground grammars;
          pg = playground;
          tree-sitter = pkgs.tree-sitter;
          artifacts = tspm.buildAllGrammars grammars {
            format = "src.tar.gz";
            metadata = true;
          };
        });

      defaultApp = forAllSystems (system: {
        type = "app";
        program = "${self.packages.${system}.playground}/run.sh";
      });

      devShells = forAllSystems (system:
        let inherit (pkgs' system) mkShell nixfmt tree-sitter;
        in { default = mkShell { buildInputs = [ nixfmt tree-sitter ]; }; });
    };
}
