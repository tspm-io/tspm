{ lib, fetchFromGitHub, tspm }:
# licenses: https://github.com/NixOS/nixpkgs/blob/7a9ee0a0efeb4e28a8cfc58a65c3266260177ac1/lib/licenses.nix
tspm.formatGrammars {
  elixir.elixir-lang = tspm.buildGrammar rec {
    version = "a11a686303355a518b0a45dea7c77c5eebb5ec22";
    src = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "tree-sitter-elixir";
      rev = version;
      sha256 = "sha256-blNLRkgAxRI1JNa9O30anSJndWVilbVaWKiXS5Yf1eA=";
    };
    meta = with lib; {
      license = licenses.asl20;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  erlang.the-mikedavis = tspm.buildGrammar rec {
    version = "47c6d15c2a25df09378af9c681d0892e5c893c39";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-erlang";
      rev = version;
      sha256 = "sha256-cLe4B4bG62tFlc3o1CboC1batTUKjw3kwyw8raFDplA=";
    };
    meta = with lib; {
      license = licenses.asl20;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  diff.the-mikedavis = tspm.buildGrammar rec {
    version = "ca750e5bbc86e5716ccf4eb9e44493b14043ec4c";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-diff";
      rev = version;
      sha256 = "sha256-keYrMxy6ATOKdA1neoAuLITOi0Usyr7mXn/w/ynl3r4=";
    };
    ref = "main";
    meta = with lib; {
      license = licenses.mit;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
}
