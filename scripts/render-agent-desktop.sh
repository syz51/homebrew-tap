#!/usr/bin/env bash
set -euo pipefail

version=""
checksums=""
output=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      [[ $# -ge 2 ]] || { echo "Missing value for --version" >&2; exit 1; }
      version="$2"
      shift 2
      ;;
    --checksums)
      [[ $# -ge 2 ]] || { echo "Missing value for --checksums" >&2; exit 1; }
      checksums="$2"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || { echo "Missing value for --output" >&2; exit 1; }
      output="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ ! "$version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
  echo "Invalid semver version: $version" >&2
  exit 1
fi

if [[ -z "$checksums" || ! -f "$checksums" ]]; then
  echo "Checksums file not found: $checksums" >&2
  exit 1
fi

if [[ -z "$output" ]]; then
  echo "Missing --output path" >&2
  exit 1
fi

sha_for() {
  local target="$1"
  local file="agent-desktop-${version}-${target}.tar.gz"
  local match
  match="$(awk -v f="$file" '$2 == f { print $1 }' "$checksums")"
  if [[ ! "$match" =~ ^[0-9a-f]{64}$ ]]; then
    echo "Missing or invalid sha256 for $file in $checksums" >&2
    exit 1
  fi
  printf '%s' "$match"
}

sha_mac_arm="$(sha_for aarch64-apple-darwin)"
sha_mac_intel="$(sha_for x86_64-apple-darwin)"
sha_linux_arm="$(sha_for aarch64-unknown-linux-gnu)"
sha_linux_intel="$(sha_for x86_64-unknown-linux-gnu)"

mkdir -p "$(dirname "$output")"

cat > "$output" <<EOF
class AgentDesktop < Formula
  desc "Rust computer-use daemon, CLI, and MCP server for macOS and Linux"
  homepage "https://github.com/syz51/agent-desktop"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v${version}/agent-desktop-${version}-aarch64-apple-darwin.tar.gz"
      sha256 "${sha_mac_arm}"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v${version}/agent-desktop-${version}-x86_64-apple-darwin.tar.gz"
      sha256 "${sha_mac_intel}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/syz51/agent-desktop/releases/download/v${version}/agent-desktop-${version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "${sha_linux_arm}"
    end
    on_intel do
      url "https://github.com/syz51/agent-desktop/releases/download/v${version}/agent-desktop-${version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "${sha_linux_intel}"
    end
  end

  def install
    bin.install "desktop"
    bin.install "desktopd"
  end

  def caveats
    <<~EOS
      \`desktop\` and \`desktopd\` are installed on PATH.
      On macOS, grant Accessibility and Screen Recording permissions before running
      \`desktopd\` locally, or follow the signed app bundle flow in the README to preserve
      TCC permissions across upgrades.
      Use \`desktop --host <alias>\` to control remote Tailscale fleet hosts.
    EOS
  end

  test do
    assert_match "desktop ${version}", shell_output("#{bin}/desktop --version")
    assert_match "desktopd ${version}", shell_output("#{bin}/desktopd --version")
    assert_match "Usage:", shell_output("#{bin}/desktop --help")
    assert_match "Usage:", shell_output("#{bin}/desktopd --help")
  end
end
EOF
