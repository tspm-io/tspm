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
        grammars = pkgs.callPackage ./grammars.nix { canopy = lib; };
        buildDefaultPackage = pkgs.runCommand "build-default-package" { } ''
          mkdir $out
          ln -s ${lib.manifest grammars}
        '';
      in {
        checks = {
          format = pkgs.runCommand "format-check" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check ${./.}/**.nix
          '';
        };
        # defaultPackage = pkgs.runCommand "build-default-package" { } ''
        #   mkdir $out
        #   ln -s ${lib.manifest grammars} manifest.json
        # '';
        defaultPackage = lib.manifest grammars;
        # hmm... could replace this with nix-devshell
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
      });
}
