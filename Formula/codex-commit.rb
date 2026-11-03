class CodexCommit < Formula
  desc "Commit Git changes with Codex, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.7/codex-commit-v0.6.7-aarch64-apple-darwin.tar.gz"
      sha256 "d6ac2c08a2e2f267ad256eab77e5626631c861a0a0d18ac2ae734aa495d39c1d"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.7/codex-commit-v0.6.7-x86_64-apple-darwin.tar.gz"
      sha256 "d507dbbf81ac27a83d908f9f13792f748b90a2b6685a52c4339c13b385a1741d"
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
    assert_match "codex-commit 0.6.7", shell_output("#{bin}/codex-commit --version")
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
