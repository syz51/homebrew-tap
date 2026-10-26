# Homebrew tap

Homebrew packages for [syz51](https://github.com/syz51)'s command-line tools.

```sh
brew tap syz51/tap
brew trust --formula syz51/tap/codex-commit
brew install syz51/tap/codex-commit
```

The trust command is required by Homebrew 7 for third-party formulae. Omit that line on older Homebrew versions that do not provide `brew trust`. It trusts only this formula.

`codex-commit` is available as a native executable for Apple Silicon and Intel Macs. It requires Git and an authenticated [Codex CLI](https://developers.openai.com/codex/cli/). Install Codex CLI separately and run `codex login` before use.

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

[MIT licensed](LICENSE).
