source "$stdenv"/setup

export tsDir="$(pwd)/tree-sitter-$language"
export XDG_CONFIG_HOME=$(pwd)/config
# used when building the grammar for tests
export XDG_CACHE_HOME=$(pwd)/cache

unpackPhase() {
  mkdir -p "$XDG_CONFIG_HOME/tree-sitter"
  ln -s "$languageConfigJson" "$XDG_CONFIG_HOME/tree-sitter/config.json"

  mkdir -p "$tsDir/$subpath"

  cp --no-preserve=mode "$src/package.json" "$tsDir/package.json"

  cp --no-preserve=mode "$src/$subpath/package.json" "$tsDir/$subpath/package.json"
  cp "$src/$subpath/grammar.js" "$tsDir/$subpath/grammar.js"
  cp --recursive --no-preserve=mode "$src/$subpath/src" "$tsDir/$subpath/src"

  for path in $copyPaths; do
    cp --recursive "$src/$path" "$tsDir/$path"
  done

  if [[ "$format" == "test" ]]; then
    cp -r "$src/queries" "$tsDir/queries/" || true
    cp -r "$src/corpus" "$tsDir/corpus/" || cp -r "$src/corpus" "$tsDir/corpus/" || true
    cp -r "$src/test" "$tsDir/test/" || true
  fi
}

buildPhase() {
  (
    eval "$preGenerate"

    cd "$tsDir/$subpath"
    tree-sitter generate --abi "$abi"

    case "$format" in
      "wasm")
        tree-sitter build-wasm
        ;;
      "test")
        tree-sitter test 2>&1 | tee "$out"
        ;;
      "src.tar.gz")
        cp "$src"/LICENSE* "$src"/license* "$src"/NOTICE* "$tsDir/$subpath/src"
        tar --create --gzip --file="$out" --directory "$tsDir/$subpath/src" .
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
      cp "$tsDir/$subpath/"*.wasm "$out"/parser.wasm
      ;;
    *)
      ;;
  esac
}

genericBuild
