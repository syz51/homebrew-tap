class AgentDesktop < Formula
  desc "Rust computer-use daemon, CLI, and MCP server for macOS and Linux"
  homepage "https://github.com/syz51/agent-desktop"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.2.0/agent-desktop-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "2f26156f930f465fbbbab531e792dc68316682e2e3665a8f295c9ef2dd3240f0"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.2.0/agent-desktop-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "70c6c22ed52be1d72f9704753f38e573636c777724b809b7ccb4fe4485ac5b8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.2.0/agent-desktop-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5bd8b2b7fce3f40bd173ab32a696cf798375436f292d6d463f8ec13555c61878"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.2.0/agent-desktop-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6f522f4e64c975de5b4845c2bbc0f75c38c2da6be4256e8731e33ebb722ca443"
    end
  end

  def install
    bin.install "desktop"
    bin.install "desktopd"
  end

  def caveats
    <<~EOS
      `desktop` and `desktopd` are installed on PATH.
      On macOS, grant Accessibility and Screen Recording permissions before running
      `desktopd` locally, or follow the signed app bundle flow in the README to preserve
      TCC permissions across upgrades.
      Use `desktop --host <alias>` to control remote Tailscale fleet hosts.
    EOS
  end

  test do
    assert_match "desktop 0.2.0", shell_output("#{bin}/desktop --version")
    assert_match "desktopd 0.2.0", shell_output("#{bin}/desktopd --version")
    assert_match "Usage:", shell_output("#{bin}/desktop --help")
    assert_match "Usage:", shell_output("#{bin}/desktopd --help")
  end
end
