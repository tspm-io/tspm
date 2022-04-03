{ lib, fetchFromGitHub, tspm }:
# licenses: https://github.com/NixOS/nixpkgs/blob/7a9ee0a0efeb4e28a8cfc58a65c3266260177ac1/lib/licenses.nix

let
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
  elixir.elixir-lang = tspm.grammar { meta.license = lib.licenses.asl20; };
  erlang.the-mikedavis = tspm.grammar { meta.license = lib.licenses.asl20; };
  ocaml.tree-sitter = tspm.grammar {
    subpath = "ocaml";
    copyPaths = [ "common" ];
    meta.license = lib.licenses.mit;
  };
  ocaml-interface.tree-sitter = tspm.grammar {
    follows = "tree-sitter/ocaml";
    subpath = "interface";
    copyPaths = [ "ocaml" "common" ];
    meta.license = lib.licenses.mit;
  };
  typescript.tree-sitter = tspm.grammar {
    subpath = "typescript";
    copyPaths = [ "common" ];
    preGenerate = ''
      mkdir -p "$tsDir/node_modules"
      ln -s ${tree-sitter-typescript-javascript-dependency} "$tsDir/node_modules/tree-sitter-javascript"
    '';
    meta.license = lib.licenses.mit;
  };
  tsx.tree-sitter = tspm.grammar {
    follows = "tree-sitter/typescript";
    subpath = "tsx";
    copyPaths = [ "common" ];
    preGenerate = ''
      mkdir -p "$tsDir/node_modules"
      ln -s ${tree-sitter-typescript-javascript-dependency} "$tsDir/node_modules/tree-sitter-javascript"
    '';
    meta.license = lib.licenses.mit;
  };
  rust.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  protobuf.yusdacra = tspm.grammar {
    # unit tests are failing
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  fish.ram02z = tspm.grammar { meta.license = lib.licenses.unlicense; };
  json.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  c.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  c-sharp.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  go.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  javascript.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  css.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  html.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  python.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  nix.cstrahan = tspm.grammar { meta.license = lib.licenses.mit; };
  ruby.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  bash.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  php.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  latex.latex-lsp = tspm.grammar {
    # this line is not necessary on the latest version of the grammar:
    # copyPaths = [ "commands.json" ];
    meta.license = lib.licenses.mit;
  };
  # takes too much CPU/RAM to build on GitHub Actions
  # lean.julian = tspm.grammar {
  #   copyPaths = [ "grammar" ];
  #   # unit tests fail on latest tree-sitter-cli
  #   doCheck = false;
  #   meta.license = lib.licenses.mit;
  # };
  julia.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  java.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  lua.nvim-treesitter = tspm.grammar { meta.license = lib.licenses.mit; };
  vue.ikatyang = tspm.grammar { meta.license = lib.licenses.mit; };
  yaml.ikatyang = tspm.grammar {
    # failing unit tests because they contain error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  haskell.tree-sitter = tspm.grammar {
    copyPaths = [ "grammar" ];
    meta.license = lib.licenses.mit;
  };
  tsq.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  cmake.uyha = tspm.grammar { meta.license = lib.licenses.mit; };
  make.alemuller = tspm.grammar {
    # failing unit tests because there are tests for error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  glsl.thehamsta = tspm.grammar {
    preGenerate = let
      tree-sitter-c = fetchFromGitHub {
        owner = "tree-sitter";
        repo = "tree-sitter-c";
        rev = "e348e8ec5efd3aac020020e4af53d2ff18f393a9";
        sha256 = "sha256-p3ugEC8FPapz9XowLm+COrkb2MI++ZUkiK6oTNJCsDo=";
      };
    in ''
      mkdir -p "$tsDir/node_modules"
      ln -s ${tree-sitter-c} "$tsDir/node_modules/tree-sitter-c"
    '';
    meta.license = lib.licenses.mit;
  };
  perl.ganezdragon = tspm.grammar { meta.license = lib.licenses.mit; };
  wgsl.szebniok = tspm.grammar { meta.license = lib.licenses.mit; };
  llvm-mir.flakebi = tspm.grammar { meta.license = lib.licenses.mit; };
  tablegen.flakebi = tspm.grammar { meta.license = lib.licenses.mit; };
  markdown.mdeiml = tspm.grammar {
    copyPaths = [ "html_entities.json" ];
    # unit tests are failing
    doCheck = false;
    # takes too many resources to build wasm on GitHub Actions
    skipPlayground = true;
    meta.license = lib.licenses.mit;
  };
  scala.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  dockerfile.camdencheek = tspm.grammar { meta.license = lib.licenses.mit; };
  regex.tree-sitter = tspm.grammar { meta.license = lib.licenses.mit; };
  git-commit.the-mikedavis = tspm.grammar { meta.license = lib.licenses.mit; };
  diff.the-mikedavis = tspm.grammar { meta.license = lib.licenses.mit; };
  git-rebase.the-mikedavis = tspm.grammar { meta.license = lib.licenses.mit; };
  git-config.the-mikedavis = tspm.grammar { meta.license = lib.licenses.mit; };
  graphql.bkegley = tspm.grammar {
    # query tests contain broken nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  elm.elm-tooling = tspm.grammar { meta.license = lib.licenses.mit; };
  iex.elixir-lang = tspm.grammar { meta.license = lib.licenses.asl20; };
  rescript.nkrkv = tspm.grammar { meta.license = lib.licenses.mit; };
  kotlin.fwcd = tspm.grammar { meta.license = lib.licenses.mit; };
  hcl.michahoffmann = tspm.grammar { meta.license = lib.licenses.asl20; };
  org.milisims = tspm.grammar {
    # unit tests contain error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  solidity.joranhonig = tspm.grammar { meta.license = lib.licenses.mit; };
  comment.stsewd = tspm.grammar { meta.license = lib.licenses.mit; };
  ledger.cbarrete = tspm.grammar { meta.license = lib.licenses.mit; };
  zig.maxxnino = tspm.grammar { meta.license = lib.licenses.mit; };
  llvm.benwilliamgraham = tspm.grammar { meta.license = lib.licenses.mit; };

  # Grammars TODO:
  # * toml.ikatyang - needs quite a few npm dependencies but could be forked
  #   and changed to avoid this
  # * cpp.tree-sitter - requires tree-sitter-c via npm without a lockfile
  # * svelte.himujjal - has an NPM dependency on tree-sitter-html
  # * twig.eirabben - does not include a license (https://github.com/eirabben/tree-sitter-twig/issues/3)
  # * dart.usernobody14 - does not include a license (https://github.com/UserNobody14/tree-sitter-dart/issues/26)
}
