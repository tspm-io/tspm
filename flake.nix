{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.callPackage ./lib { };
        grammars = pkgs.callPackage ./grammars.nix { tspm = lib; };
      in {
        checks = {
          format = pkgs.runCommand "format-check" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**.nix
            touch $out
          '';
          tests = lib.buildAllGrammars grammars { format = "test"; };
        };
        defaultPackage = lib.buildAllGrammars grammars { format = "test"; };
        # hmm... could replace this with nix-devshell
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
      });
}
