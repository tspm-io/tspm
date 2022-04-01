# Tips for Tree-Sitter Grammar Authors

This is a free-form collection of notes for how to write a good tree-sitter
grammar. Feel free to contribute new tips!

### `.gitattributes`

A `.gitattributes` file in the top-level of a grammar repository can tell
git and GitHub how to treat certain files in the repository. A common
configuration is to mark the generated files in `src` as generated. see this
example [from `tree-sitter-elixir`][elixir-gitattributes]:

```
/src/**/* linguist-generated=true
/src/scanner.cc linguist-generated=false
# Exclude test files from language stats
/test/**/*.ex linguist-documentation=true
```

Here the generated files in `src` are marked as `linguist-generated`, which
excludes the files from the repository's language calculation (the colored
language bar on the repo's main page) and prevents changes to those files
from being shown in pull requests on GitHub. Note that `src/scanner.cc` is not
marked as generated, as it is an implementation of a custom external scanner.

Marking files under the `test` directories as `linguist-documentation` excludes
the files from the language calculation.

A more extreme approach for marking generated `src` files as generated is to
use `-diff`, like so:

```
/src/**/* linguist-generated=true -diff
```

Which prevents changes to the given files from being shown when using
`git diff` or in verbose commits.

### The `sep1` rule

Languages often-times have syntax that supports a set of comma-separated
values, usually in the case of arguments for a function.

This function [from `tree-sitter-elixir`][elixir-sep1] is handy and can be
re-used when the separator is not a comma:

```js
{
  // ..
  arguments: ($) => seq("(", sep1($._expression, ","), ")"),
  // ..
}

function sep1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)));
}
```

### Formatting

Many grammars use the popular [prettier][prettier] code formatter for ensuring
a consistent style in the `grammar.js`. A common configuration for this in
`package.json` looks like this example [from
`tree-sitter-elixir`][elixir-format]:

```js
// ..
"scripts": {
  "test": "tree-sitter test",
  "format": "prettier --trailing-comma es5 --write grammar.js",
  "format-check": "prettier --trailing-comma es5 --check grammar.js"
},
"devDependencies": {
  "prettier": "^2.3.2",
  // ..
},
// ..
```

Contributors then may run `npm run format` to format `grammar.js`. Proper
formatting can be checked in CI with `npm run format-check`.

### Licensing

> Disclaimer: I am not a lawyer and this is not legal advice.

Please license your grammar! The GitHub [licensing docs][licensingdocs] state

> You're under no obligation to choose a license. However, without a license,
> the default copyright laws apply, meaning that you retain all rights to your
> source code and no one may reproduce, distribute, or create derivative works
> from your work.

TSPM is not allowed to package your grammar if you do not declare a license
(or if your declared license prohibits distribution).

The MIT license is overwhelmingly popular among grammar repositories but other
good choices exist. "Official" grammars tend to follow the language's license.

[elixir-gitattributes]: https://github.com/elixir-lang/tree-sitter-elixir/blob/b4027d7cfc96935b50878bdf9faf80bd64ac73cf/.gitattributes
[elixir-sep1]: https://github.com/elixir-lang/tree-sitter-elixir/blob/b4027d7cfc96935b50878bdf9faf80bd64ac73cf/grammar.js#L840-L842
[prettier]: https://prettier.io/
[elixir-format]: https://github.com/elixir-lang/tree-sitter-elixir/blob/b4027d7cfc96935b50878bdf9faf80bd64ac73cf/package.json#L12-L24
[licensingdocs]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository#choosing-the-right-license
