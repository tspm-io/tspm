# canopy

open-source package manager for tree-sitter grammars 🌳

### Why?

Currently, tree-sitter grammars distributed using git repositories, which
pushes the burden of writing a well written package to the grammar authors.
This is a bit problematic because:

- grammar repositories typically contain items like documentation, queries,
  and tests that are unnecessary to package
- grammar authors are not incentivized to react quickly to updates to
  tree-sitter or its ABI
