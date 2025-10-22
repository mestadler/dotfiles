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
  local src="$1" dst="$2"
  local abs_src
  abs_src="$(readlink -f "$src")"
  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$abs_src" ]; then
      echo "↔️  Link exists (ok): ${dst} → ${abs_src}"
      return
    fi
    local ts; ts="$(date +%Y%m%d-%H%M%S)"
    local bak="${dst}.bak.${ts}"
    echo "🗂  Backing up ${dst} → ${bak}"
    mv -f "$dst" "$bak"
  fi

  ln -s "$abs_src" "$dst"
  echo "🔗 Linked ${dst} → ${abs_src}"
}

# --- Always set global gitignore ---
[ -f ".gitignore_global" ] && {
  link_file ".gitignore_global" "${HOME}/.gitignore_global"
  git config --global core.excludesfile "${HOME}/.gitignore_global"
} || echo "⚠️  Missing .gitignore_global in repo"

# --- Link common dotfiles if present ---
for f in \
  .bashrc \
  .bashrc-developer \
  .bash_aliases \
  .bash_completions_extras \
  .gitconfig \
  .vimrc \
  .profile
do
  [ -f "$f" ] && link_file "$f" "${HOME}/$f"
done

# --- Post-steps: ensure .bashrc sources extras (defensive) ---
if ! grep -q '.bash_completions_extras' "${HOME}/.bashrc"; then
  echo '[[ -f "$HOME/.bash_completions_extras" ]] && source "$HOME/.bash_completions_extras"' >> "${HOME}/.bashrc"
  echo "➕ Added source line for .bash_completions_extras to ~/.bashrc"
fi
if ! grep -q '.bash_aliases' "${HOME}/.bashrc"; then
  echo '[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"' >> "${HOME}/.bashrc"
  echo "➕ Added source line for .bash_aliases to ~/.bashrc"
fi
if ! grep -q '.bashrc-developer' "${HOME}/.bashrc"; then
  echo '[ -f "$HOME/.bashrc-developer" ] && source "$HOME/.bashrc-developer"' >> "${HOME}/.bashrc"
  echo "➕ Added source line for .bashrc-developer to ~/.bashrc"
fi

# --- Summary ---
echo
echo "🎉 Done."
echo "   Repo: ${DOTFILES_DIR}"
echo "   Global ignore: $(git config --global --get core.excludesfile || echo 'not set')"
echo "   Symlinks created for:"
printf "   - %s\n" ".bashrc" ".bashrc-developer" ".bash_aliases" ".bash_completions_extras" ".gitconfig" ".gitignore_global"
echo
echo "Restart your shell or run:  source ~/.bashrc"
echo

