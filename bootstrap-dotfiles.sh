#!/usr/bin/env bash
# =========================================
# Bootstrap personal dotfiles (symlink mode)
# Author: Martin Stadler (mestadler)
# =========================================

set -euo pipefail

REPO_OWNER="mestadler"
REPO_NAME="dotfiles"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
DOTFILES_DIR="${HOME}/DevOps/${REPO_NAME}"

echo "🧰 Bootstrapping dotfiles (symlink mode) for ${USER}"

need() { command -v "$1" >/dev/null 2>&1 || { echo "📦 Installing $1..."; sudo apt update -y && sudo apt install -y "$1"; }; }

# --- Dependencies ---
need git
need gh

# --- Clone repo if missing ---
if [ ! -d "${DOTFILES_DIR}/.git" ]; then
  mkdir -p "$(dirname "${DOTFILES_DIR}")"
  echo "🔗 Cloning ${REPO_OWNER}/${REPO_NAME} → ${DOTFILES_DIR}"
  gh auth login
  gh repo clone "${REPO_OWNER}/${REPO_NAME}" "${DOTFILES_DIR}"
else
  echo "✅ Repo already present at ${DOTFILES_DIR}"
fi

cd "${DOTFILES_DIR}"

# --- helper: link with backup ---
link_file() {
  local src="$1"       # repo path (relative or absolute)
  local dst="$2"       # target path in $HOME
  local abs_src
  abs_src="$(readlink -f "$src")"

  # create parent dir for dst if needed
  mkdir -p "$(dirname "$dst")"

  # if exists and not the correct symlink, back it up
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$abs_src" ]; then
      echo "↔️  Link exists (ok): ${dst} → ${abs_src}"
      return
    fi
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    local bak="${dst}.bak.${ts}"
    echo "🗂  Backing up ${dst} → ${bak}"
    mv -f "$dst" "$bak"
  fi

  ln -s "$abs_src" "$dst"
  echo "🔗 Linked ${dst} → ${abs_src}"
}

# --- Always set global gitignore ---
if [ -f ".gitignore_global" ]; then
  link_file ".gitignore_global" "${HOME}/.gitignore_global"
  git config --global core.excludesfile "${HOME}/.gitignore_global"
else
  echo "⚠️  Missing .gitignore_global in repo"
fi

# --- Optional dotfiles (link if present) ---
for f in .bashrc .bashrc-developer .gitconfig .vimrc .profile ; do
  if [ -f "$f" ]; then
    link_file "$f" "${HOME}/$f"
  fi
done

# --- Summary ---
echo
echo "🎉 Done."
echo "   Repo: ${DOTFILES_DIR}"
echo "   Global ignore: $(git config --global --get core.excludesfile || echo 'not set')"
echo "   Tip: edit in repo (vi ${DOTFILES_DIR}/.bashrc), changes are live."
echo

