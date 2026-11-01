class CodexCommit < Formula
  desc "Commit Git changes with Codex, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.4/codex-commit-v0.6.4-aarch64-apple-darwin.tar.gz"
      sha256 "3b6aaa181928f5be4a3bda124e788d69882832f58ae974b34d214623aacc7e0b"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.4/codex-commit-v0.6.4-x86_64-apple-darwin.tar.gz"
      sha256 "1ad0db069fbdd526f7c5d3974c73c39dc5c3c83171b866945a499ef37c535edb"
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
    assert_match "codex-commit 0.6.4", shell_output("#{bin}/codex-commit --version")
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
