Excellent — here’s a concise, durable **`README.md`** you can drop directly into your `dotfiles` repo.
It’s written for your workflow (Debian-based systems, `vi` editor, `gh` CLI, global `.gitignore`, future expansion for `.bashrc`, `.gitconfig`, etc.).

---

````markdown
# 🧰 Dotfiles — Personal Setup (mestadler)

Personal configuration files for Debian-based development environments.

---

## 📦 Contents
- `.gitignore_global` — universal ignore file (Python, AI/ML, DevOps)
- (optional future files) `.bashrc`, `.bashrc-developer`, `.gitconfig`, `.vimrc`, `.profile`

---

## ⚙️ Bootstrap on a New Machine

### 1. Clone this repo
```bash
mkdir -p ~/DevOps
cd ~/DevOps
gh auth login
gh repo clone mestadler/dotfiles
````

### 2. Apply the global Git ignore

```bash
cp ~/DevOps/dotfiles/.gitignore_global ~/
git config --global core.excludesfile ~/.gitignore_global
```

Confirm:

```bash
git config --global --get core.excludesfile
# Expected output: /home/$USER/.gitignore_global
```

### 3. (Optional) Apply other config files

When you add more dotfiles later:

```bash
cp ~/DevOps/dotfiles/.bashrc ~/
cp ~/DevOps/dotfiles/.gitconfig ~/
cp ~/DevOps/dotfiles/.vimrc ~/
source ~/.bashrc
```

---

## 🧩 Verify Global Ignore

```bash
cd ~/DevOps
mkdir testrepo && cd testrepo && git init
touch test.log model.ckpt tmp/tmpfile.ai
git status  # → should show nothing (ignored)
```

---

## 🔁 Updating Dotfiles

```bash
cd ~/DevOps/dotfiles
git pull
# or after editing locally
git add .
git commit -m "Update dotfiles"
git push
```

---

## 🪶 Notes

* Editor preference: `vi`
* Target systems: Debian / Ubuntu / Linux Mint
* Authentication: personal `mestadler` GitHub account via `gh`
* Repository visibility: Private

---

**License:** Personal use only
© Martin Stadler

```

