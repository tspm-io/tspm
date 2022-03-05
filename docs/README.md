# TSPM docs

This document has some general documentation on TSPM. There are more specific
documents as well:

* [adding new grammars][add-new-grammar]
* [tips for grammar authors][tips]

### Motivation

Currently, tree-sitter grammars distributed using git repositories, which
pushes the burden of writing a well written package to the grammar authors.
This is a bit problematic because:

* grammar repositories typically contain items like documentation, queries,
  and tests that are unnecessary in packages but are good for the grammars
  themselves
* grammar authors do not usually have any reason to update tree-sitter
  versions
* TODO: ABI (might become a sub-bullet of above)

TSPM focuses on the packaging aspect, reducing the operational burden of a
grammar maintainer. If TSPM becomes widely adopted by tree-sitter consumers,
there may no longer be a need to commit generated files in grammar
repositories.

### Scope

TSPM's current focus is to optimize grammar packaging for [Helix][helix].
A minimal goal for TSPM is to act as a package registry for grammars' `src/`
directories. Hosting compiled parser artifacts (`.so` and `.dll` files) is
probably also within scope. Packaging for queries alongside their grammars
is also desired, but there are no concrete implementation plans at the moment.
Depending on how TSPM is intended on being used by tree-sitter consumers, a
CLI client for the registry (probably called `tspm`) may be in scope.

Some goals are out of scope for now:

* semantic versioning of grammars
    * grammars tend to make breaking changes very often, so this is actually
      probably a bad idea
* security guarantees
    * this would certainly be nice to have, but ultimately it is difficult
      to ensure any grammar does not execute arbitrary code - grammars could
      hide such things in external scanner implementations, and manual
      review is currently the only tool to protect against such abuses
* package download counts
    * I'd be open to this if TSPM becomes well adopted and it's not too
      expensive to track

### Why Nix?

[Nix][nix] is a tool for declarative package management. It is known for its
use in large-scale package registries like [`nixpkgs`][nixpkgs], but it is
general enough to be used to write new package registries.

Technically, all packaging currently done in TSPM could be accomplished
through Makefiles or shell scripts. There is some variance between how
tree-sitter grammars are structured in the wild, though. Some need
dependencies from local directories, submodules, or NPM. One in particular
had a `grammar.js` written in Typescript instead (i.e. `grammar.ts`) until
recently. These variances **are in scope** for TSPM. Using Nix allows us to
more easily write custom builders and plug in custom options with reasonable
defaults.

Nix also sets up network and file-system sandboxing during builds, which is
necessary when packaging tree-sitter grammars because a `grammar.js` may
contain arbitrary code.

### Infrastructure

Currently, TSPM uses the following infrastructure:

* GitHub Actions - for automations like building grammars and wasm bindings
* GitHub Pages - for hosting the playground

Note that there is no infrastructure _yet_ for the package registry. The
following backends are currently being considered for packages:

* [DigitalOcean Spaces][do-spaces] - a very cheap approach with a
  straight-forward path for storing artifacts and serving them
* [Fastly][fastly] - a well-known CDN provider (used by hex.pm), and it can
  use DO Spaces for object storage, which could provide a good pivot

### Costs

TSPM currently rides on the free services provided by GitHub for open-source
projects. Once a back-end is chosen for the package registry (see the
"infrastructure" section above), there will start being costs. I plan on
documenting the total monthly costs. I may also set up GitHub Sponsors so that
those who wish to help me cover the costs may donate.

[helix]: https://github.com/helix-editor/helix
[nix]: https://nixos.org/
[nixpkgs]: https://github.com/NixOS/nixpkgs
[do-spaces]: https://www.digitalocean.com/blog/spaces-now-includes-cdn
[fastly]: https://www.fastly.com/
[tips]: ./grammar-author-tips.md
[add-new-grammar]: ./add-new-grammar.md
