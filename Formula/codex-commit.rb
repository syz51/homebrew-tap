class CodexCommit < Formula
  desc "Commit Git changes with Codex Luna at Max reasoning, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.3.0/codex-commit-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "41144a5ebdd8e2f9152fb8d177096b7092d1a4f889cb03a5157c34a8c00e9179"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.3.0/codex-commit-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "235255fcab19be8c2a0502dcbb580fa1f94f5a5cb91509bc9f1cab0999ca0699"
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
      The default mode grants Codex full local command access. Use --push to enable pushing.
    EOS
  end

  test do
    assert_match "codex-commit 0.3.0", shell_output("#{bin}/codex-commit --version")
    assert_match "Usage:", shell_output("#{bin}/codex-commit --help")
    assert_match "#compdef codex-commit", (zsh_completion/"_codex-commit").read
    assert_match "--push", (zsh_completion/"_codex-commit").read
    assert_path_exists bash_completion/"codex-commit"
    assert_path_exists fish_completion/"codex-commit.fish"
    with_env(PATH: "/usr/bin:/bin") do
      system "git", "init", "-b", "main"
      output = shell_output("#{bin}/codex-commit --dry-run")
      assert_match "Push: disabled", output
      assert_match "Model: gpt-6-luna", output
      assert_match "Reasoning: max", output
    end
  end
end
