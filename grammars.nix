{ lib, fetchFromGitHub, tspm }:
# licenses: https://github.com/NixOS/nixpkgs/blob/7a9ee0a0efeb4e28a8cfc58a65c3266260177ac1/lib/licenses.nix
[
  rec {
    language = "elixir";
    author = "elixir-lang";
    src = fetchFromGitHub {
      owner = author;
      repo = "tree-sitter-elixir";
      rev = "a11a686303355a518b0a45dea7c77c5eebb5ec22";
      sha256 = lib.fakeSha256;
    };
    files = tspm.defaultFiles;
    meta = with lib; {
      license = licenses.asl20;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  }
  rec {
    language = "erlang";
    author = "the-mikedavis";
    src = fetchFromGitHub {
      owner = author;
      repo = "tree-sitter-erlang";
      rev = "47c6d15c2a25df09378af9c681d0892e5c893c39";
      sha256 = lib.fakeSha256;
    };
    files = tspm.defaultFiles;
    meta = with lib; {
      license = licenses.asl20;
      maintainer = [ tspm.maintainers.the-mikedavis ];
    };
  }
]
