class CodexCommit < Formula
  desc "Commit Git changes with Codex Luna at Max reasoning, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.2.2/codex-commit-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "d890ec5a59605b05aa62cf5d5917eeeb5400ac55c58e257eaceeb08748b9d1d8"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.2.2/codex-commit-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "83efacab5ce7c3a9c5f6a6b2f63c4d545f38871374015e35824794d01d0af643"
    end
  end

  def install
    bin.install "codex-commit"
  end

  def caveats
    <<~EOS
      Git must be available on PATH; macOS Command Line Tools Git is supported.
      Install Codex CLI separately and run `codex login` before using codex-commit.
      The default mode grants Codex full local command access. Use --push to enable pushing.
    EOS
  end

  test do
    assert_match "codex-commit 0.2.2", shell_output("#{bin}/codex-commit --version")
    assert_match "Usage:", shell_output("#{bin}/codex-commit --help")
    with_env(PATH: "/usr/bin:/bin") do
      system "git", "init", "-b", "main"
      output = shell_output("#{bin}/codex-commit --dry-run")
      assert_match "Push: disabled", output
      assert_match "Model: gpt-6-luna", output
      assert_match "Reasoning: max", output
    end
  end
end
