class CodexCommit < Formula
  desc "Commit Git changes with Codex, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.10/codex-commit-v0.6.10-aarch64-apple-darwin.tar.gz"
      sha256 "1ff9edc3c0a20990ad43c1ad95d9b3d54261ee21877b75eea741924f90038687"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.10/codex-commit-v0.6.10-x86_64-apple-darwin.tar.gz"
      sha256 "08fb32d83f53f3a4ccfe26f3b2a7a516b71fc6dee058c613c1af14ca5d906096"
    end
  end

  def install
    bin.install "codex-commit"
    generate_completions_from_executable(bin/"codex-commit", "--completions")
  end

  def caveats
    <<~EOS
      Git must be available on PATH; macOS Command Line Tools Git is supported.
      Install Codex CLI separately and run `codex login` before using codex-commit.
      Sandbox settings follow your Codex configuration unless overridden. Use --push to enable pushing.
    EOS
  end

  test do
    assert_match "codex-commit 0.6.10", shell_output("#{bin}/codex-commit --version")
    assert_match "Usage:", shell_output("#{bin}/codex-commit --help")
    assert_match "#compdef codex-commit", (zsh_completion/"_codex-commit").read
    assert_match "--push", (zsh_completion/"_codex-commit").read
    assert_path_exists bash_completion/"codex-commit"
    assert_path_exists fish_completion/"codex-commit.fish"
    with_env(PATH: "/usr/bin:/bin") do
      system "git", "init", "-b", "main"
      output = shell_output("#{bin}/codex-commit --no-config --dry-run")
      assert_match "Push: disabled", output
      assert_match "Model: gpt-6-luna", output
      assert_match "Reasoning: low", output
    end
  end
end
