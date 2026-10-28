class CodexCommit < Formula
  desc "Commit Git changes with Codex, with optional push"
  homepage "https://github.com/syz51/codex-commit"
  license "MIT"

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.1/codex-commit-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "fb9ea9c45a76f7420cb3cd78d8f5f759f042e97d1f5b72967c7659ee4cddc109"
    end
    on_intel do
      url "https://github.com/syz51/codex-commit/releases/download/v0.6.1/codex-commit-v0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "6a63ce9276834979887c3601fa680ade7354f1b3f3feeb9952c405746551fb58"
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
    assert_match "codex-commit 0.6.1", shell_output("#{bin}/codex-commit --version")
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
      assert_match "Reasoning: max", output
    end
  end
end
