# upstream:
# https://github.com/NixOS/nixpkgs/blob/3e072546ea98db00c2364b81491b893673267827/pkgs/development/tools/parsing/tree-sitter/default.nix
{ lib, stdenv, fetchFromGitHub, which, rustPlatform, emscripten, Security
, callPackage, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic, webUISupport ? true }:

let
  version = "0.20.6";
  # sha256 = lib.fakeSha256;
  sha256 = "sha256-zaxy8VCfJKK8NtfuFFojmmP5a19FP1zO/eB5q1EoQPw=";
  # cargoSha256 = lib.fakeSha256;
  cargoSha256 = "sha256-sOOhzm2nz+HC6dvT+8hj/wh19o+OB2zQ6Uz+H89txSA=";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    inherit sha256;
    fetchSubmodules = true;
  };
in rustPlatform.buildRustPackage {
  pname = "tree-sitter";
  inherit src version cargoSha256;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ which ] ++ lib.optionals webUISupport [ emscripten ];

  postPatch = lib.optionalString (!webUISupport) ''
    # remove web interface
    sed -e '/pub mod web_ui/d' \
        -i cli/src/lib.rs
    sed -e 's/web_ui,//' \
        -e 's/web_ui::serve(&current_dir.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
        -i cli/src/main.rs
  '';

  # Compile web assembly with emscripten. The --debug flag prevents us from
  # minifying the JavaScript; passing it allows us to side-step more Node
  # JS dependencies for installation.
  preBuild = lib.optionalString webUISupport ''
    bash ./script/build-wasm --debug
  '';

  postInstall = ''
    PREFIX=$out make install
    ${lib.optionalString (!enableShared) "rm $out/lib/*.so{,.*}"}
    ${lib.optionalString (!enableStatic) "rm $out/lib/*.a"}
  '';

  # test result: FAILED. 120 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "A parser generator tool and an incremental parsing library";
    longDescription = ''
      Tree-sitter is a parser generator tool and an incremental parsing library.
      It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

      Tree-sitter aims to be:

      * General enough to parse any programming language
      * Fast enough to parse on every keystroke in a text editor
      * Robust enough to provide useful results even in the presence of syntax errors
      * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
    '';
    license = licenses.mit;
  };
}
