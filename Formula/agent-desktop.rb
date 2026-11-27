class AgentDesktop < Formula
  desc "Rust computer-use daemon, CLI, and MCP server for macOS and Linux"
  homepage "https://github.com/syz51/agent-desktop"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.1.0/agent-desktop-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "999af4f8ced2816db3cdddc161e70623779db35635b60e17fc0af68f4f9b2799"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.1.0/agent-desktop-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "e5f58ea337ad124f4943e9a12620b3027ef8ca00b0f8b15d6883fe8c47402402"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.1.0/agent-desktop-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "617b53588a4de2e23fd69b42a4d38d3572b894c3cf86478cab9135518872822d"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.1.0/agent-desktop-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d0ae9530b8bdaf7f5e1840f4b61a9d88cbde21b7554a73de7942f7c817af00c"
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
    assert_match "desktop 0.1.0", shell_output("#{bin}/desktop --version")
    assert_match "desktopd 0.1.0", shell_output("#{bin}/desktopd --version")
    assert_match "Usage:", shell_output("#{bin}/desktop --help")
    assert_match "Usage:", shell_output("#{bin}/desktopd --help")
  end
end
