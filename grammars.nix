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
    meta.license = lib.licenses.asl20;
  };
  erlang.the-mikedavis = tspm.grammar rec {
    version = "47c6d15c2a25df09378af9c681d0892e5c893c39";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-erlang";
      rev = version;
      sha256 = "sha256-cLe4B4bG62tFlc3o1CboC1batTUKjw3kwyw8raFDplA=";
    };
    meta.license = lib.licenses.asl20;
  };
  ocaml.tree-sitter = tspm.grammar {
    version = tree-sitter-ocaml-version;
    src = tree-sitter-ocaml;
    subpath = "ocaml";
    copyPaths = [ "common" ];
    meta.license = lib.licenses.mit;
  };
  ocaml-interface.tree-sitter = tspm.grammar {
    version = tree-sitter-ocaml-version;
    src = tree-sitter-ocaml;
    subpath = "interface";
    copyPaths = [ "ocaml" "common" ];
    meta.license = lib.licenses.mit;
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
    meta.license = lib.licenses.mit;
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
    meta.license = lib.licenses.mit;
  };
  rust.tree-sitter = tspm.grammar rec {
    version = "a360da0a29a19c281d08295a35ecd0544d2da211";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-rust";
      rev = version;
      sha256 = "sha256-v0MxQgim3N5UjQCTNDLY8brsy6NKtQ9L4gUWzof6yk4=";
    };
    meta.license = lib.licenses.mit;
  };
  protobuf.yusdacra = tspm.grammar rec {
    version = "5aef38d655f76a6b0d172340eed3766c93b3124c";
    src = fetchFromGitHub {
      owner = "yusdacra";
      repo = "tree-sitter-protobuf";
      rev = version;
      sha256 = "sha256-h86NQAIRU+mUroa0LqokMtEVd7U5BXo/DADc2UUZQzI=";
    };
    # unit tests are failing
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  fish.ram02z = tspm.grammar rec {
    version = "04e54ab6585dfd4fee6ddfe5849af56f101b6d4f";
    src = fetchFromGitHub {
      owner = "ram02z";
      repo = "tree-sitter-fish";
      rev = version;
      sha256 = "sha256-JHzywKNh48vENgSKZjIRvVvd1zBwkcz6xQmsABX6IKA=";
    };
    meta.license = lib.licenses.unlicense;
  };
  json.tree-sitter = tspm.grammar rec {
    version = "65bceef69c3b0f24c0b19ce67d79f57c96e90fcb";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-json";
      rev = version;
      sha256 = "sha256-F4rgtAVGBEYtUHnhKY0r0MoXnrXYNGIgTjRHqapz5I4=";
    };
    meta.license = lib.licenses.mit;
  };
  c.tree-sitter = tspm.grammar rec {
    version = "f05e279aedde06a25801c3f2b2cc8ac17fac52ae";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-c";
      rev = version;
      sha256 = "sha256-LsLhCKUfB6uccQ4mBRXxsw7+dDnQmJht0yFGrF6tOuY=";
      # sha256 = lib.fakeSha256;
    };
    meta.license = lib.licenses.mit;
  };
  c-sharp.tree-sitter = tspm.grammar rec {
    version = "53a65a908167d6556e1fcdb67f1ee62aac101dda";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-c-sharp";
      rev = version;
      sha256 = "sha256-ouYSeWYEJW6nPwE1YP7G19AfejBtED+YPffWiQXwN1c=";
    };
    meta.license = lib.licenses.mit;
  };
  go.tree-sitter = tspm.grammar rec {
    version = "0fa917a7022d1cd2e9b779a6a8fc5dc7fad69c75";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-go";
      rev = version;
      sha256 = "sha256-r7pJTuSR381J8tB1PIgjFi4eBXeaO9to8xd90Lwn/k0=";
    };
    meta.license = lib.licenses.mit;
  };
  javascript.tree-sitter = tspm.grammar rec {
    version = "4a95461c4761c624f2263725aca79eeaefd36cad";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-javascript";
      rev = version;
      sha256 = "sha256-lXOG8hWnJaYtf5kVRgfBhKazYmAyjxQhCfIW4Z86R30=";
    };
    meta.license = lib.licenses.mit;
  };
  css.tree-sitter = tspm.grammar rec {
    version = "94e10230939e702b4fa3fa2cb5c3bc7173b95d07";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-css";
      rev = version;
      sha256 = "sha256-jfsLkwvbmt88TmGDejMR4exF5z9zQeXHcHUEuJy2IHk=";
    };
    meta.license = lib.licenses.mit;
  };
  html.tree-sitter = tspm.grammar rec {
    version = "d93af487cc75120c89257195e6be46c999c6ba18";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-html";
      rev = version;
      sha256 = "sha256-vqtB32K+9pVV7FHEwbC2eNMHOlFgh9DRMjmu49na58E=";
    };
    meta.license = lib.licenses.mit;
  };
  python.tree-sitter = tspm.grammar rec {
    version = "d6210ceab11e8d812d4ab59c07c81458ec6e5184";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-python";
      rev = version;
      sha256 = "sha256-EzZjuOhaXYNs4rIRoG3y1rzy4C1SpdxYE0ThTWK/dJw=";
    };
    meta.license = lib.licenses.mit;
  };
  nix.cstrahan = tspm.grammar rec {
    version = "50f38ceab667f9d482640edfee803d74f4edeba5";
    src = fetchFromGitHub {
      owner = "cstrahan";
      repo = "tree-sitter-nix";
      rev = version;
      sha256 = "sha256-bSwowUMzxd+jSt6SXS5hq188KTeLZQ2HEDv1s9Jy8YU=";
    };
    meta.license = lib.licenses.mit;
  };
  ruby.tree-sitter = tspm.grammar rec {
    version = "dfff673b41df7fadcbb609c6338f38da3cdd018e";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-ruby";
      rev = version;
      sha256 = "sha256-MF4N7pvhxtRaeUDKaKKanJxJjWXj1FINAVi2ouEMULQ=";
    };
    meta.license = lib.licenses.mit;
  };
  bash.tree-sitter = tspm.grammar rec {
    version = "a8eb5cb57c66f74c63ab950de081207cccf52017";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-bash";
      rev = version;
      sha256 = "sha256-nvkflLlj2QTlJqgTJn4LqzXMPTs6ThQ+grHhwuSyJLM=";
    };
    meta.license = lib.licenses.mit;
  };
  php.tree-sitter = tspm.grammar rec {
    version = "57f855461aeeca73bd4218754fb26b5ac143f98f";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-php";
      rev = version;
      sha256 = "sha256-bEMsvkFr9dQ/51mpUyT6Ia42AN4NctPtqzRaxBH7/ew=";
    };
    meta.license = lib.licenses.mit;
  };
  latex.latex-lsp = tspm.grammar rec {
    version = "7f720661de5316c0f8fee956526d4002fa1086d8";
    src = fetchFromGitHub {
      owner = "latex-lsp";
      repo = "tree-sitter-latex";
      rev = version;
      sha256 = "sha256-1QQNvxsu9MYW6xC9fXOUATnY/R1Rs/fWIEZ/NvaqTpI=";
    };
    # this line is not necessary on the latest version of the grammar:
    copyPaths = [ "commands.json" ];
    meta.license = lib.licenses.mit;
  };
  lean.julian = tspm.grammar rec {
    version = "d98426109258b266e1e92358c5f11716d2e8f638";
    src = fetchFromGitHub {
      owner = "julian";
      repo = "tree-sitter-lean";
      rev = version;
      sha256 = "sha256-U4ObSk4mtpp/gq8fnDQOKFfrgZ8/SuF6v5UhqxyAhWk=";
    };
    copyPaths = [ "grammar" ];
    # unit tests fail on latest tree-sitter-cli
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  julia.tree-sitter = tspm.grammar rec {
    version = "12ea597262125fc22fd2e91aa953ac69b19c26ca";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-julia";
      rev = version;
      sha256 = "sha256-UwdCZu1e3VwIiLZXo3sKWsbJ9jthY5q7vseUncc8rWY=";
    };
    meta.license = lib.licenses.mit;
  };
  java.tree-sitter = tspm.grammar rec {
    version = "bd6186c24d5eb13b4623efac9d944dcc095c0dad";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-java";
      rev = version;
      sha256 = "sha256-//+cev/D6Ye6kgwpKiBOJ3MyvPJ/IVKcS+yfdGEc0hc=";
    };
    meta.license = lib.licenses.mit;
  };
  lua.nvim-treesitter = tspm.grammar rec {
    version = "6f5d40190ec8a0aa8c8410699353d820f4f7d7a6";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "tree-sitter-lua";
      rev = version;
      sha256 = "sha256-LSxVplyS9sTAr+2wEbTaYHs04TPw/6p8wsZoQyiAWhU=";
    };
    meta.license = lib.licenses.mit;
  };
  vue.ikatyang = tspm.grammar rec {
    version = "91fe2754796cd8fba5f229505a23fa08f3546c06";
    src = fetchFromGitHub {
      owner = "ikatyang";
      repo = "tree-sitter-vue";
      rev = version;
      sha256 = "sha256-NeuNpMsKZUP5mrLCjJEOSLD6tlJpNO4Z/rFUqZLHE1A=";
    };
    meta.license = lib.licenses.mit;
  };
  yaml.ikatyang = tspm.grammar rec {
    version = "0e36bed171768908f331ff7dff9d956bae016efb";
    src = fetchFromGitHub {
      owner = "ikatyang";
      repo = "tree-sitter-yaml";
      rev = version;
      sha256 = "sha256-bpiT3FraOZhJaoiFWAoVJX1O+plnIi8aXOW2LwyU23M=";
    };
    # failing unit tests because they contain error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  haskell.tree-sitter = tspm.grammar rec {
    version = "b6ec26f181dd059eedd506fa5fbeae1b8e5556c8";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-haskell";
      rev = version;
      sha256 = "sha256-EQw1UlceF4LG+naHxMT2nev46WBvV+dtpgXS50HmbRA=";
    };
    copyPaths = [ "grammar" ];
    meta.license = lib.licenses.mit;
  };
  tsq.tree-sitter = tspm.grammar rec {
    version = "b665659d3238e6036e22ed0e24935e60efb39415";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-tsq";
      rev = version;
      sha256 = "sha256-qXk1AFwZbqfixInG4xvGBnC/HqibXvmTmZ1LcbmAbA0=";
    };
    meta.license = lib.licenses.mit;
  };
  cmake.uyha = tspm.grammar rec {
    version = "f6616f1e417ee8b62daf251aa1daa5d73781c596";
    src = fetchFromGitHub {
      owner = "uyha";
      repo = "tree-sitter-cmake";
      rev = version;
      sha256 = "sha256-RrKbSlbPzI3BGl6p0qbL0qW5unS7vXGWRVU+0AhirKw=";
    };
    meta.license = lib.licenses.mit;
  };
  make.alemuller = tspm.grammar rec {
    version = "a4b9187417d6be349ee5fd4b6e77b4172c6827dd";
    src = fetchFromGitHub {
      owner = "alemuller";
      repo = "tree-sitter-make";
      rev = version;
      sha256 = "sha256-qQqapnKKH5X8rkxbZG5PjnyxvnpyZHpFVi/CLkIn/x0=";
    };
    # failing unit tests because there are tests for error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  glsl.theHamsta = tspm.grammar rec {
    version = "88408ffc5e27abcffced7010fc77396ae3636d7e";
    src = fetchFromGitHub {
      owner = "theHamsta";
      repo = "tree-sitter-glsl";
      rev = version;
      sha256 = "sha256-jQrBz7dDVn9p4et1Oe034YYBRXzi+hdSkqyi3TsQUv8=";
    };
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
  perl.ganezdragon = tspm.grammar rec {
    version = "0ac2c6da562c7a2c26ed7e8691d4a590f7e8b90a";
    src = fetchFromGitHub {
      owner = "ganezdragon";
      repo = "tree-sitter-perl";
      rev = version;
      sha256 = "sha256-XLwY7p5Gnn3fnBw6EG/6qh0O3+1MMA+5ZyQmmllUn6A=";
    };
    meta.license = lib.licenses.mit;
  };
  wgsl.szebniok = tspm.grammar rec {
    version = "f00ff52251edbd58f4d39c9c3204383253032c11";
    src = fetchFromGitHub {
      owner = "szebniok";
      repo = "tree-sitter-wgsl";
      rev = version;
      sha256 = "sha256-7CexXBK0kKCx92zexgxcXv47ykCWZhZrC1vCIiqQdUc=";
    };
    meta.license = lib.licenses.mit;
  };
  llvm-mir.flakebi = tspm.grammar rec {
    version = "06fabca19454b2dc00c1b211a7cb7ad0bc2585f1";
    src = fetchFromGitHub {
      owner = "flakebi";
      repo = "tree-sitter-llvm-mir";
      rev = version;
      sha256 = "sha256-uQwKSNJfoeDDSi4YZwudUZD3kxkngvW2ZP1qtVKvfqg=";
    };
    meta.license = lib.licenses.mit;
  };
  tablegen.flakebi = tspm.grammar rec {
    version = "568dd8a937347175fd58db83d4c4cdaeb6069bd2";
    src = fetchFromGitHub {
      owner = "flakebi";
      repo = "tree-sitter-tablegen";
      rev = version;
      sha256 = "sha256-lFyayrTExte4A5tFoqo9oCIKvsi7g55WI+/d57ayA/A=";
    };
    meta.license = lib.licenses.mit;
  };
  markdown.mdeiml = tspm.grammar rec {
    version = "b49b2da50864171eff56acc8ba067c3540a3991f";
    src = fetchFromGitHub {
      owner = "mdeiml";
      repo = "tree-sitter-markdown";
      rev = version;
      sha256 = "sha256-HeVrjtqjgd3E9NOJlRMQqaxoKGoIFbWgetc47Wa9vqk=";
    };
    copyPaths = [ "html_entities.json" ];
    # unit tests are failing
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  scala.tree-sitter = tspm.grammar rec {
    version = "0a3dd53a7fc4b352a538397d054380aaa28be54c";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-scala";
      rev = version;
      sha256 = "sha256-8W4OJA0/EeyiXnh+MwZykAlJl8TAVIby1M6MVeyNntM=";
    };
    meta.license = lib.licenses.mit;
  };
  dockerfile.camdencheek = tspm.grammar rec {
    version = "7af32bc04a66ab196f5b9f92ac471f29372ae2ce";
    src = fetchFromGitHub {
      owner = "camdencheek";
      repo = "tree-sitter-dockerfile";
      rev = version;
      sha256 = "sha256-5dbttYlrp7xsfh1b5Av6ol6w69LVtOvFYzLcXAcyHho=";
    };
    meta.license = lib.licenses.mit;
  };
  regex.tree-sitter = tspm.grammar rec {
    version = "e1cfca3c79896ff79842f057ea13e529b66af636";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-regex";
      rev = version;
      sha256 = "sha256-lDsr3sLrLf6wXu/juIA+bTtv1SBo+Jgwqw/6yBAE0kg=";
    };
    meta.license = lib.licenses.mit;
  };
  git-commit.the-mikedavis = tspm.grammar rec {
    version = "7ae23de633de41f8f5b802f6f05b6596df6d00c1";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-git-commit";
      rev = version;
      sha256 = "sha256-IqNV05155z9yPnHXgGHEbbkvPfM7hk61+C93L29UPFA=";
    };
    meta.license = lib.licenses.mit;
  };
  diff.the-mikedavis = tspm.grammar rec {
    version = "ca750e5bbc86e5716ccf4eb9e44493b14043ec4c";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-diff";
      rev = version;
      sha256 = "sha256-keYrMxy6ATOKdA1neoAuLITOi0Usyr7mXn/w/ynl3r4=";
    };
    meta.license = lib.licenses.mit;
  };
  git-rebase.the-mikedavis = tspm.grammar rec {
    version = "332dc528f27044bc4427024dbb33e6941fc131f2";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-git-rebase";
      rev = version;
      sha256 = "sha256-xelepogMgyzOtvubBMPnjnoAvMna8cmi8gb0Se5z6LA=";
    };
    meta.license = lib.licenses.mit;
  };
  git-config.the-mikedavis = tspm.grammar rec {
    version = "0e4f0baf90b57e5aeb62dcdbf03062c6315d43ea";
    src = fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "tree-sitter-git-config";
      rev = version;
      sha256 = "sha256-xelepogMgyzOtvubBMPnjnoAvMna8cmi8gb0Se5z6LA=";
    };
    meta.license = lib.licenses.mit;
  };
  graphql.bkegley = tspm.grammar rec {
    version = "5e66e961eee421786bdda8495ed1db045e06b5fe";
    src = fetchFromGitHub {
      owner = "bkegley";
      repo = "tree-sitter-graphql";
      rev = version;
      sha256 = "sha256-NvE9Rpdp4sALqKSRWJpqxwl6obmqnIIdvrL1nK5peXc=";
    };
    # query tests contain broken nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  elm.elm-tooling = tspm.grammar rec {
    version = "bd50ccf66b42c55252ac8efc1086af4ac6bab8cd";
    src = fetchFromGitHub {
      owner = "elm-tooling";
      repo = "tree-sitter-elm";
      rev = version;
      sha256 = "sha256-fhJTyHD8M0PTDUJ1e0SmrUspRx0oQWNFqt6zaQOiSdM=";
    };
    meta.license = lib.licenses.mit;
  };
  iex.elixir-lang = tspm.grammar rec {
    version = "39f20bb51f502e32058684e893c0c0b00bb2332c";
    src = fetchFromGitHub {
      owner = "elixir-lang";
      repo = "tree-sitter-iex";
      rev = version;
      sha256 = "sha256-YRVxMz9VqZ00bG0tQ/IDxf/8UkK3/OYZTIMxsQfknII=";
    };
    meta.license = lib.licenses.asl20;
  };
  rescript.nkrkv = tspm.grammar rec {
    version = "5063c17c712b6e81fa575dbaddc5966667f4c1d9";
    src = fetchFromGitHub {
      owner = "nkrkv";
      repo = "tree-sitter-rescript";
      rev = version;
      sha256 = "sha256-MAy65kjXvK07/ecwfju/6tsmy6bObOpr8zpzKhWONG0=";
    };
    meta.license = lib.licenses.mit;
  };
  kotlin.fwcd = tspm.grammar rec {
    version = "a4f71eb9b8c9b19ded3e0e9470be4b1b77c2b569";
    src = fetchFromGitHub {
      owner = "fwcd";
      repo = "tree-sitter-kotlin";
      rev = version;
      sha256 = "sha256-aRMqhmZKbKoggtBOgtFIq0xTP+PgeD3Qz6DPJsAFPRQ=";
    };
    meta.license = lib.licenses.mit;
  };
  hcl.michahoffmann = tspm.grammar rec {
    version = "3cb7fc28247efbcb2973b97e71c78838ad98a583";
    src = fetchFromGitHub {
      owner = "michahoffmann";
      repo = "tree-sitter-hcl";
      rev = version;
      sha256 = "sha256-2a8bVk3x2E8HMNgy0eWspOpqiLXzx7By+Fz2reHg50E=";
    };
    meta.license = lib.licenses.asl20;
  };
  # failing unit tests because error nodes
  org.milisims = tspm.grammar rec {
    version = "1c3eb533a9cf6800067357b59e03ac3f91fc3a54";
    src = fetchFromGitHub {
      owner = "milisims";
      repo = "tree-sitter-org";
      rev = version;
      sha256 = "sha256-N3hx5DK4utGTb5DJoGfCsobyY0bT8nOb6nvGSRuEsxs=";
    };
    # unit tests contain error nodes
    doCheck = false;
    meta.license = lib.licenses.mit;
  };
  solidity.joranhonig = tspm.grammar rec {
    version = "5585e0739a248137d9561d835a915efb2db5ac3d";
    src = fetchFromGitHub {
      owner = "joranhonig";
      repo = "tree-sitter-solidity";
      rev = version;
      sha256 = "sha256-rgttlYMWW/ji+2kGZKyPRLx52NXoyupP+7ZNFnRQuBE=";
      # sha256 = lib.fakeSha256;
    };
    meta.license = lib.licenses.mit;
  };

  # Grammars TODO:
  # * toml.ikatyang - needs quite a few npm dependencies but could be forked
  #   and changed to avoid this
  # * cpp.tree-sitter - requires tree-sitter-c via npm without a lockfile
  # * twig.eirabben - does not include a license
  # * ledger.cbarrete - does not include a license
  # * svelte.himujjal - has an NPM dependency on tree-sitter-html
  # * zig.maxxnino - does not include a license
  # * comment.stsewd - does not include a license
  # * llvm.benwilliamgraham - does not include a license
  # * dart.usernobody14 - does not include a license
}
