# homebrew-tap

Homebrew tap for [ratect](https://github.com/or1can/ratect) — publishing
[`ratect-compat`](https://github.com/or1can/ratect/blob/main/decisions/0001-two-binaries.md)
and `ratect` formulae.

## Usage

```bash
brew install or1can/tap/ratect-compat
brew install or1can/tap/ratect
```

Formulae here are published automatically by ratect's own release pipeline
(`.github/workflows/release.yml`'s `publish-homebrew-formula` job) — see
[decisions/0010](https://github.com/or1can/ratect/blob/main/decisions/0010-release-binary-distribution.md)
in the `ratect` repo. Don't hand-edit `Formula/*.rb` here; it's overwritten
on the next release.
