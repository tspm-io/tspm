# TSPM 🌲

[![CI](https://github.com/the-mikedavis/tspm/actions/workflows/ci.yml/badge.svg)](https://github.com/the-mikedavis/tspm/actions/workflows/ci.yml)

_An open-source package manager for tree-sitter grammars_

### Why?

Currently, tree-sitter grammars distributed using git repositories, which
pushes the burden of writing a well written package to the grammar authors.
This is a bit problematic because:

- grammar repositories typically contain items like documentation, queries,
  and tests that are unnecessary to package
- grammar authors are not incentivized to react quickly to updates to
  tree-sitter or its ABI

### Scope

The most basic feature I want is fast tarball downloads for the minimal set
of files of a grammar (`src/` and `LICENSE*`).

Another problem I'd love to solve is packaging queries. Each consumer of
tree-sitter grammars has their own set of captures and conventions. TSPM
should allow you to download a bundle of queries flavored for your use-case
which are tested to work with some version of a grammar.
