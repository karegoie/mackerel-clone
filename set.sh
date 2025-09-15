#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  curl ca-certificates gnupg git sudo build-essential pkg-config \
  libgtk-3-dev libwebkit2gtk-4.1-dev libjavascriptcoregtk-4.1-dev libsoup-3.0-dev \
  libayatana-appindicator3-dev librsvg2-dev libssl-dev \
  python3 python3-pip

# Node LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Rust (non-interactive)
if [ ! -d "${HOME}/.cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
. "${HOME}/.cargo/env"

grep -q 'cargo/env' "${HOME}/.bashrc" || echo '. "$HOME/.cargo/env"' >> "${HOME}/.bashrc"

cargo install --locked tauri-cli

npm install -g npm

APP_NAME="mackerel"
if [ ! -d "${APP_NAME}" ]; then
  npm create tauri-app@latest "${APP_NAME}" -- --template svelte-ts
fi

cd "${APP_NAME}"

if [ -f package.json ]; then
  npm install --frozen-lockfile || npm install
fi

# npm tauri build

apt-get clean
rm -rf /var/lib/apt/lists/*