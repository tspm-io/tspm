source $stdenv/setup

export tsDir=$(pwd)/tree-sitter-$language
export XDG_CONFIG_HOME=$(pwd)/config
# used when building the grammar for tests
export XDG_CACHE_HOME=$(pwd)/cache

unpackPhase() {
  mkdir -p $XDG_CONFIG_HOME/tree-sitter
  ln -s $languageConfigJson $XDG_CONFIG_HOME/tree-sitter/config.json

  # TODO: npm dependencies, submodules, sub-paths
  mkdir $tsDir
  cp $src/grammar.js $tsDir/
  cp $src/package.json $tsDir/

  if [[ "$format" == "test" ]]; then
    cp -r $src/queries $tsDir/queries/ || true
    cp -r $src/corpus $tsDir/corpus/ || true
    cp -r $src/test $tsDir/test/ || true
  fi
}

buildPhase() {
  # TODO compiled outputs? or handle outside of nix?
  cd $tsDir
  tree-sitter generate

  case "$format" in
    "wasm")
      tree-sitter build-wasm
      ;;
    "test")
      tree-sitter test 2>&1 | tee $tsDir/results.txt
      ;;
    *)
      ;;
  esac

  cd -
}

installPhase() {
  case "$format" in
    "src")
      mkdir $out
      cp $src/LICENSE* $src/license* $src/NOTICE* $out/
      cp -r $tsDir/src $out/
      ;;
    "wasm")
      mkdir $out
      cp $src/LICENSE* $src/license* $src/NOTICE* $out/
      cp $tsDir/*.wasm $out/parser.wasm
      ;;
    "test")
      cp $tsDir/results.txt $out
      ;;
    *)
      ;;
  esac
}

genericBuild
