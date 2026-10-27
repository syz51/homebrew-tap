# Homebrew tap

Homebrew packages for [syz51](https://github.com/syz51)'s command-line tools.

```sh
brew tap syz51/tap
brew trust --formula syz51/tap/codex-commit
brew install syz51/tap/codex-commit
```

The trust command is required by Homebrew 7 for third-party formulae. Omit that line on older Homebrew versions that do not provide `brew trust`. It trusts only this formula.

`codex-commit` is available as a native executable for Apple Silicon and Intel Macs. It requires Git and an authenticated [Codex CLI](https://developers.openai.com/codex/cli/). Install Codex CLI separately and run `codex login` before use.

The formula uses Git already available on `PATH`, including macOS Command Line Tools Git, without requiring Homebrew's Git package. `codex-commit` checks for Git when it runs and reports an error if it is missing.

```sh
codex-commit         # commit existing changes
codex-commit --push  # also push
```

For usage, source, and security reporting, see [codex-commit](https://github.com/syz51/codex-commit).

To update:

```sh
brew update
brew upgrade syz51/tap/codex-commit
```

CI installs and tests the published package on Apple Silicon and Intel macOS. Formula updates must use checksums from the verified upstream release.

The **Update published releases** workflow checks for a new stable `codex-commit` release every 15 minutes. GitHub may delay scheduled runs. It verifies the immutable release, source tag, archive attestations, and checksums, then generates the formula with the release's Rust helper. A formula-update PR merges automatically after the required Apple Silicon and Intel checks pass. It preserves branch protections and does not force-push.

The updater uses this repository's built-in GitHub token; no cross-repository token or permanent publishing secret is required. Repository settings must allow GitHub Actions to create pull requests and allow auto-merge. The updater dispatches the native CI workflow explicitly so bot-created updates do not require manual workflow approval.

To retry discovery after a release or a temporary failure, run **Update published releases** from the Actions tab on `main`, or use:

```sh
gh workflow run update.yml --repo syz51/homebrew-tap --ref main
```

Retries reuse the existing release branch and PR. An already-current version is left unchanged; conflicting branch edits or attempted downgrades stop with an error for maintainer review.

[MIT licensed](LICENSE).
