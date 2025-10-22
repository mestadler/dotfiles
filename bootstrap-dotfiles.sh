#!/usr/bin/env bash
# =========================================
# Bootstrap personal dotfiles (symlink mode)
# Martin Stadler (mestadler)
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

# --- Normalise permissions locally (non-fatal) ---
chmod 755 bootstrap-dotfiles.sh ai-check.sh 2>/dev/null || true
for f in .bashrc .bashrc-developer .bash_aliases .bash_aliases_ai .bash_completions_extras .gitconfig .gitignore_global .profile .vimrc; do
  [ -f "$f" ] && chmod 644 "$f" || true
done

# --- Always set global gitignore ---
[ -f ".gitignore_global" ] && {
  link_file ".gitignore_global" "${HOME}/.gitignore_global"
  git config --global core.excludesfile "${HOME}/.gitignore_global"
} || echo "⚠️  Missing .gitignore_global in repo"

# --- Link all managed files ---
for f in \
  .bashrc \
  .bashrc-developer \
  .bash_aliases \
  .bash_aliases_ai \
  .bash_completions_extras \
  .gitconfig \
  .vimrc \
  .profile
do
  [ -f "$f" ] && link_file "$f" "${HOME}/$f"
done

# --- Ensure ai-check on PATH ---
if [ -f "ai-check.sh" ]; then
  mkdir -p "$HOME/bin"
  chmod 755 ai-check.sh 2>/dev/null || true
  link_file "ai-check.sh" "$HOME/bin/ai-check"
fi

# --- Quick hardware check: detect GPU vendor ---
echo
if lspci | grep -qi nvidia; then
  echo "💡 Detected NVIDIA GPU — ensure nvidia-container-toolkit installed for containerd"
elif lspci | grep -qi amd; then
  echo "💡 Detected AMD GPU — ensure ROCm packages and /dev/kfd permissions OK"
else
  echo "💡 No discrete GPU detected"
fi

# --- Summary ---
echo
echo "🎉 Done."
echo "   Repo: ${DOTFILES_DIR}"
echo "   Symlinks created for:"
printf "   - %s\n" ".bashrc" ".bashrc-developer" ".bash_aliases" ".bash_aliases_ai" ".bash_completions_extras" ".gitconfig" ".gitignore_global" ".vimrc"
echo "   + ai-check available in ~/bin"
echo
echo "Restart your shell or run:  source ~/.bashrc"
echo
