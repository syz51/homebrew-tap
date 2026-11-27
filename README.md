# Homebrew tap

Homebrew packages for [syz51](https://github.com/syz51)'s command-line tools.

```sh
brew tap syz51/tap
```

## Formulae

### `agent-desktop`

Fast Rust computer-use daemon (`desktopd`), CLI (`desktop`), and MCP server for macOS and Linux.

```sh
brew trust --formula syz51/tap/agent-desktop
brew install syz51/tap/agent-desktop
```

For macOS signed app bundle setup (persistent TCC permissions across upgrades), Linux `Xvfb` mode, Tailscale fleet configuration, source, and security reporting, see [agent-desktop](https://github.com/syz51/agent-desktop).

### `codex-commit`

```sh
brew trust --formula syz51/tap/codex-commit
brew install syz51/tap/codex-commit
```

The trust command is required by Homebrew 7 for third-party formulae. Omit that line on older Homebrew versions that do not provide `brew trust`. It trusts only the named formula.

`codex-commit` is available as a native executable for Apple Silicon and Intel Macs. It requires Git and an authenticated [Codex CLI](https://developers.openai.com/codex/cli/). Install Codex CLI separately and run `codex login` before use.

The formula uses Git already available on `PATH`, including macOS Command Line Tools Git, without requiring Homebrew's Git package. `codex-commit` checks for Git when it runs and reports an error if it is missing.

```sh
codex-commit         # commit existing changes
codex-commit --push  # also push
```

For usage, source, and security reporting, see [codex-commit](https://github.com/syz51/codex-commit).

## Updating

```sh
brew update
brew upgrade syz51/tap/agent-desktop syz51/tap/codex-commit
```

CI installs and tests every published package on Apple Silicon and Intel macOS. Formula updates must use checksums from the verified upstream release.

The **Update published releases** workflow checks for new stable `codex-commit` and `agent-desktop` releases every 15 minutes. GitHub may delay scheduled runs. It verifies immutable releases, release and archive attestations, and checksums, then generates each updated formula. A formula-update PR merges automatically after the required Apple Silicon and Intel checks pass. It preserves branch protections and does not force-push.

Release verification and formula generation use the repository's read-only GitHub token (`codex-commit` uses its upstream Rust helper; `agent-desktop` uses `scripts/render-agent-desktop.sh`). Updating the branch, opening the PR, and enabling auto-merge use a short-lived installation token from a dedicated GitHub App installed only on `syz51/homebrew-tap`, with Contents and Pull requests write permissions. Normal App-authenticated PR events run the required native checks; [GitHub excludes manually dispatched checks from PR requirements](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks#checks-from-some-workflow-jobs-are-not-evaluated). The installation token is revoked when the job finishes, and the updater does not use a cross-repository token.

One-time setup: allow repository auto-merge, then configure the GitHub environment `release-updates` with the variable `RELEASE_APP_CLIENT_ID` and secret `RELEASE_APP_PRIVATE_KEY`. Restrict that environment to the `main` branch. The App key is used only in the update job after read-only release verification and formula generation have completed; it is never provided to upstream code or the preparation job.

To retry discovery after a release or a temporary failure, run **Update published releases** from the Actions tab on `main`, or use:

```sh
gh workflow run update.yml --repo syz51/homebrew-tap --ref main
```

Retries reuse the existing release branch and PR. An already-current version is left unchanged; conflicting branch edits or attempted downgrades stop with an error for maintainer review.

[MIT licensed](LICENSE).
