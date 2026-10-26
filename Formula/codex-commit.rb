class CodexCommit < Formula
  desc "Commit Git changes with Codex Luna at Max reasoning, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on "git"
  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.2.0/codex-commit-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "b5dbf09e5ab01a4da607f0145d2404f5043e34aa3b88865bc3e1b6ca625c40e8"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.2.0/codex-commit-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "4b76005c8477db2d5caafac13e245897529bced1a5c2821706fc6ef2583a2feb"
    end
  end

  def install
    bin.install "codex-commit"
  end

  def caveats
    <<~EOS
      Install Codex CLI separately and run `codex login` before using codex-commit.
      The default mode grants Codex full local command access. Use --push to enable pushing.
    EOS
  end

  test do
    assert_match "codex-commit 0.2.0", shell_output("#{bin}/codex-commit --version")
    assert_match "Usage:", shell_output("#{bin}/codex-commit --help")
    system "git", "init", "-b", "main"
    output = shell_output("#{bin}/codex-commit --dry-run")
    assert_match "Push: disabled", output
    assert_match "Model: gpt-6-luna", output
    assert_match "Reasoning: max", output
  end
end
