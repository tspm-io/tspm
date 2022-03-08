source "$stdenv"/setup

export tsDir="$(pwd)/tree-sitter-$language"
export XDG_CONFIG_HOME=$(pwd)/config
# used when building the grammar for tests
export XDG_CACHE_HOME=$(pwd)/cache

unpackPhase() {
  mkdir -p "$XDG_CONFIG_HOME/tree-sitter"
  ln -s "$languageConfigJson" "$XDG_CONFIG_HOME/tree-sitter/config.json"

  mkdir "$tsDir"

  cp --no-preserve=mode "$src/package.json" "$tsDir"/

  for path in $includePaths; do
    mkdir -p "$tsDir/$path"

    cp "$src/$path/grammar.js" "$tsDir/$path/grammar.js"
    cp --no-preserve=mode "$src/$path/package.json" "$tsDir/$path/package.json"

    # 'src/' will be updated by 'tree-sitter generate', so we copy
    # without preserving the mode to allow tree-sitter to write
    # to the otherwise read-only files.
    cp --recursive --no-preserve=mode "$src/$path/src" "$tsDir/$path/src"
  done

  if [[ "$format" == "test" ]]; then
    cp -r "$src/queries" "$tsDir/queries/" || true
    cp -r "$src/corpus" "$tsDir/corpus/" || cp -r "$src/corpus" "$tsDir/corpus/" || true
    cp -r "$src/test" "$tsDir/test/" || true
  fi
}

buildPhase() {
  (
    cd "$tsDir/$subpath"
    tree-sitter generate

    case "$format" in
      "wasm")
        tree-sitter build-wasm
        ;;
      "test")
        tree-sitter test 2>&1 | tee "$out"
        ;;
      "src.tar.gz")
        tar --create --gzip --file="$out" "$tsDir/$subpath/src"
        ;;
      *)
        ;;
    esac
  )
}

installPhase() {
  case "$format" in
    "src")
      mkdir "$out"
      cp "$src"/LICENSE* "$src"/license* "$src"/NOTICE* "$out"/
      cp -r "$tsDir/$subpath"/src/* "$out"/
      ;;
    "wasm")
      mkdir "$out"
      cp "$src"/LICENSE* "$src"/license* "$src"/NOTICE* "$out"/
      cp "$tsDir"/*.wasm "$out"/parser.wasm
      ;;
    *)
      ;;
  esac
}

genericBuild
