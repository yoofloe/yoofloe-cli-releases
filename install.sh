#!/usr/bin/env bash
set -euo pipefail

REPO="${YOOFLOE_REPO:-yoofloe/yoofloe-cli-releases}"

case "$(uname -s)" in
  Linux) platform="linux" ;;
  Darwin) platform="macos" ;;
  *)
    echo "Unsupported platform: $(uname -s)" >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64|amd64) arch="x64" ;;
  arm64|aarch64) arch="arm64" ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

asset="yoofloe-${platform}-${arch}"
url="https://github.com/${REPO}/releases/latest/download/${asset}"
install_dir="${YOOFLOE_INSTALL_DIR:-$HOME/.local/bin}"
tmp_dir="$(mktemp -d)"
tmp_binary="$tmp_dir/yoofloe"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

echo "Downloading ${asset} from ${url}"
curl -fsSL "$url" -o "$tmp_binary"

mkdir -p "$install_dir"
install "$tmp_binary" "$install_dir/yoofloe"
chmod +x "$install_dir/yoofloe"

echo "Installed yoofloe to $install_dir/yoofloe"
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    echo "Add $install_dir to PATH if 'yoofloe' is not found in a new terminal."
    ;;
esac
