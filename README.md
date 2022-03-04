# TSPM 🌲

[![CI][ci-badge]](ci-file)

_An open-source [tree-sitter][tree-sitter] package manager_

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

[ci-badge]: https://github.com/the-mikedavis/tspm/actions/workflows/ci.yml/badge.svg
[ci-file]: https://github.com/the-mikedavis/tspm/actions/workflows/ci.yml
[tree-sitter]: https://github.com/tree-sitter/tree-sitter
