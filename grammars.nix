{ lib, tspm }:
# licenses: https://github.com/NixOS/nixpkgs/blob/7a9ee0a0efeb4e28a8cfc58a65c3266260177ac1/lib/licenses.nix
tspm.formatGrammars {
  elixir.elixir-lang = tspm.buildGrammar {
    remote = "https://github.com/elixir-lang/tree-sitter-elixir";
    revision = "a11a686303355a518b0a45dea7c77c5eebb5ec22";
    meta = with lib; {
      license = licenses.asl20;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
  # erlang.the-mikedavis = tspm.buildGrammar {
  #   remote = "https://github.com/the-mikedavis/tree-sitter-erlang";
  #   revision = "47c6d15c2a25df09378af9c681d0892e5c893c39";
  #   meta = with lib; {
  #     license = licenses.asl20;
  #     maintainer = [ tspm.maintainers.the-mikedavis ];
  #   };
  # };
  diff.the-mikedavis = tspm.buildGrammar {
    remote = "https://github.com/the-mikedavis/tree-sitter-diff";
    revision = "ca750e5bbc86e5716ccf4eb9e44493b14043ec4c";
    ref = "main";
    meta = with lib; {
      license = licenses.mit;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  };
}
