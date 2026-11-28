class AgentDesktop < Formula
  desc "Rust computer-use daemon, CLI, and MCP server for macOS and Linux"
  homepage "https://github.com/syz51/agent-desktop"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.3.0/agent-desktop-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "77802d08ce9a6f2e9807ff3afd7e1ce18bca695e533fc66d1e5c5e8e1cab77a8"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.3.0/agent-desktop-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "12412cc99966bb62124a9bd8075b3dde3a202fe08232559723688c5ba244ccec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.3.0/agent-desktop-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d0be20ed560ea4462d1e3c17a062c13354e9ba229a350ef35173e60b83fd5d9a"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v0.3.0/agent-desktop-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9e3eede2f4c23740d72e82d96061b7a73e4bc49a7273e0b4328f8cdd72c073c2"
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
    assert_match "desktop 0.3.0", shell_output("#{bin}/desktop --version")
    assert_match "desktopd 0.3.0", shell_output("#{bin}/desktopd --version")
    assert_match "Usage:", shell_output("#{bin}/desktop --help")
    assert_match "Usage:", shell_output("#{bin}/desktopd --help")
  end
end
