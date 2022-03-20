{ lib, fetchFromGitHub, tspm }:
# licenses: https://github.com/NixOS/nixpkgs/blob/7a9ee0a0efeb4e28a8cfc58a65c3266260177ac1/lib/licenses.nix

let
  tree-sitter-ocaml-version = "23d419ba45789c5a47d31448061557716b02750a";
  tree-sitter-ocaml = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-ocaml";
    rev = tree-sitter-ocaml-version;
    sha256 = "sha256-aBqW3uKSgNrZKwLrujZvzttimHDPykaNe6DHOJpTA64=";
  };
  tree-sitter-typescript-version = "e8e8e8dc2745840b036421b4e43286750443cb13";
  tree-sitter-typescript = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-typescript";
    rev = tree-sitter-typescript-version;
    sha256 = "sha256-GAfJnrtyt+BiB6HPEpVQpG7E9nXMzw6uxiiQ+6Q7O/w=";
  };
  tree-sitter-typescript-javascript-dependency = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-javascript";
    rev = "fdeb68ac8d2bd5a78b943528bb68ceda3aade2eb";
    sha256 = "sha256-x+BJrcceuKU2ARZD8mjoA1ni0b6P2C4YiE1YgcbMvpw=";
  };
in tspm.formatGrammars {
  elixir.elixir-lang = tspm.grammar rec {
    version = "a11a686303355a518b0a45dea7c77c5eebb5ec22";
    src = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "tree-sitter-elixir";
      rev = version;
      sha256 = "sha256-blNLRkgAxRI1JNa9O30anSJndWVilbVaWKiXS5Yf1eA=";
    };
    meta = with lib; {
      license = licenses.asl20;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  erlang.the-mikedavis = tspm.grammar rec {
    version = "47c6d15c2a25df09378af9c681d0892e5c893c39";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-erlang";
      rev = version;
      sha256 = "sha256-cLe4B4bG62tFlc3o1CboC1batTUKjw3kwyw8raFDplA=";
    };
    meta = with lib; {
      license = licenses.asl20;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  diff.the-mikedavis = tspm.grammar rec {
    version = "ca750e5bbc86e5716ccf4eb9e44493b14043ec4c";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-diff";
      rev = version;
      sha256 = "sha256-keYrMxy6ATOKdA1neoAuLITOi0Usyr7mXn/w/ynl3r4=";
    };
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  ocaml.tree-sitter = tspm.grammar {
    version = tree-sitter-ocaml-version;
    src = tree-sitter-ocaml;
    subpath = "ocaml";
    copyPaths = [ "common" ];
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  ocaml-interface.tree-sitter = tspm.grammar {
    version = tree-sitter-ocaml-version;
    src = tree-sitter-ocaml;
    subpath = "interface";
    copyPaths = [ "ocaml" "common" ];
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  typescript.tree-sitter = tspm.grammar {
    version = tree-sitter-typescript-version;
    src = tree-sitter-typescript;
    subpath = "typescript";
    copyPaths = [ "common" ];
    preGenerate = ''
      mkdir -p "$tsDir/node_modules"
      ln -s ${tree-sitter-typescript-javascript-dependency} "$tsDir/node_modules/tree-sitter-javascript"
    '';
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  tsx.tree-sitter = tspm.grammar {
    version = tree-sitter-typescript-version;
    src = tree-sitter-typescript;
    subpath = "tsx";
    copyPaths = [ "common" ];
    preGenerate = ''
      mkdir -p "$tsDir/node_modules"
      ln -s ${tree-sitter-typescript-javascript-dependency} "$tsDir/node_modules/tree-sitter-javascript"
    '';
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  rust.tree-sitter = tspm.grammar rec {
    version = "a360da0a29a19c281d08295a35ecd0544d2da211";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-rust";
      rev = version;
      sha256 = "sha256-v0MxQgim3N5UjQCTNDLY8brsy6NKtQ9L4gUWzof6yk4=";
    };
    meta = with lib; {
      license = licenses.mit;
      package-maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
}
