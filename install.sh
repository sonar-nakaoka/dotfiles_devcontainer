#!/usr/bin/env bash
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# starship 本体をインストール（存在しなければ）
if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# starship.toml をシンボリックリンク
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# .bashrc に .bashrc.local を読み込む行を一度だけ追加
LINE='[ -f ~/dotfiles_devcontainer/.bashrc.local ] && source ~/dotfiles_devcontainer/.bashrc.local'
grep -qxF "$LINE" "$HOME/.bashrc" || echo "$LINE" >> "$HOME/.bashrc"

# git submodule を初期化して更新(--remoteでsubmodule側リポジトリの最新を取る)
# submoduleを手動で更新するときは git submodule update --remote --merge
git -C "$DOTFILES_DIR" submodule update --init --remote --merge skills
# ホームディレクトリにclaude個人用ディレクトリを作成
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/skills" "$HOME/.claude/"
