# 🧰 Dotfiles — Personal Development Setup

**Martin Stadler (mestadler)**

Optimized configuration files for Debian-based cloud-native, Kubernetes, and AI/ML development environments.

---

##  Features

###  Bash Configuration
- **Optimized loading order** - No duplicates, proper sequence
- **Custom tool completions** - kubectl, helm, flux, oras, cosign from `/usr/local/bin`
- **Smart PATH management** - Custom binaries take precedence
- **Modular design** - Separate files for different concerns
- **Fast startup** - Lazy-loaded completions

###  Tools & Aliases
- **Kubernetes** - kubectl shortcuts (k, kg, kgp, kl, ke, kd)
- **Containers** - nerdctl/containerd primary (nc, ncl, ncu, ncd)
- **Git** - Smart aliases (gs, gl, gc, gp, gpl)
- **AI/GPU** - Mixed NVIDIA/AMD support with auto-detection
- **GitHub CLI** - Quick clone, repo management

###  Vim Configuration
- Line numbers enabled
- System clipboard integration (Ctrl+C/V)
- Syntax highlighting
- Sensible defaults for YAML/JSON

###  Git Setup
- GitHub CLI credential helper
- Global gitignore (secrets, AI models, build artifacts)
- Rebase by default
- Useful aliases

---

##  Contents

```
dotfiles/
├── .bashrc                     # Main bash config (optimized)
├── .bash_aliases               # General system & tool aliases
├── .bash_aliases_ai            # AI/GPU-specific (CUDA/ROCm)
├── .bash_completions_extras    # Auto-completions for custom tools
├── .bashrc-developer           # Developer functions & environment
├── .gitconfig                  # Git configuration
├── .gitignore_global           # Universal ignore patterns
├── .vimrc                      # Vim configuration
├── ai-check.sh                 # GPU detection utility
├── bootstrap-dotfiles.sh       # Automated setup script
└── README.md                   # This file
```

---

##  Quick Start

### Fresh Installation

```bash
# Prerequisites
sudo apt update
sudo apt install -y git gh xclip

# Clone repo
mkdir -p ~/DevOps
cd ~/DevOps
gh auth login
gh repo clone mestadler/dotfiles

# Run bootstrap script
cd dotfiles
chmod +x bootstrap-dotfiles.sh
./bootstrap-dotfiles.sh

# Reload shell
source ~/.bashrc
```

The bootstrap script will:
- ✅ Create symlinks from `~/DevOps/dotfiles/` → `~/`
- ✅ Backup existing files with timestamps
- ✅ Set up global gitignore
- ✅ Detect GPU hardware
- ✅ Make `ai-check` available in `~/bin`

### Manual Setup (Alternative)

```bash
cd ~/DevOps/dotfiles

# Create symlinks manually
ln -sf ~/DevOps/dotfiles/.bashrc ~/.bashrc
ln -sf ~/DevOps/dotfiles/.bash_aliases ~/.bash_aliases
ln -sf ~/DevOps/dotfiles/.bash_aliases_ai ~/.bash_aliases_ai
ln -sf ~/DevOps/dotfiles/.bash_completions_extras ~/.bash_completions_extras
ln -sf ~/DevOps/dotfiles/.bashrc-developer ~/.bashrc-developer
ln -sf ~/DevOps/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/DevOps/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/DevOps/dotfiles/.vimrc ~/.vimrc

# Set up git
git config --global core.excludesfile ~/.gitignore_global

# Reload
source ~/.bashrc
```

---

##  Key Aliases & Commands

### Kubernetes
```bash
k               # kubectl
kg              # kubectl get
kgp             # kubectl get pods -A
kgs             # kubectl get svc -A
kgn             # kubectl get nodes
kl <pod>        # kubectl logs -f
ke <pod>        # kubectl exec -it
kd <resource>   # kubectl describe
kctx            # List contexts
kns <namespace> # Switch namespace

# Functions
kctxs           # Show current context + available contexts
kn              # Show current namespace
kn <namespace>  # Switch namespace
klog <prefix>   # Quick logs for pod matching prefix
```

### Containers (nerdctl/containerd)
```bash
nc              # nerdctl
ncl             # nerdctl ps -a
ncr <image>     # nerdctl run --rm -it
nce <container> # nerdctl exec -it
ncu             # nerdctl compose up -d
ncd             # nerdctl compose down
ncclean         # System prune
nccleanall      # Clean everything including volumes

# Also available: d, docker (aliases to nerdctl)
```

### Git
```bash
gs              # git status -sb
gl              # git log --oneline --graph --decorate --all
gc              # git commit -v
gp              # git push
gpl             # git pull --rebase
gco <branch>    # git checkout
gb              # git branch -vv
gd              # git diff
```

### GitHub CLI
```bash
ghc <owner/repo>        # gh repo clone
ghr                     # gh repo view --web
ghp                     # gh pr view --web
gh_clone <owner/repo>   # Clone and cd into directory
gh_create_repo <name>   # Create and push repo
```

### AI/GPU
```bash
ai_backend              # Detect CUDA vs ROCm
gpuinfo                 # Show GPU information
ptinfo                  # PyTorch configuration
ncnv <image>            # Run NVIDIA GPU container
ncrocm <image>          # Run AMD ROCm container
ncaigpu <image>         # Auto-detect and run appropriate container
nvver                   # NVIDIA version info
rocmver                 # ROCm version info
```

### System
```bash
aptu            # apt update && upgrade
apti <package>  # apt install
aptr            # apt autoremove
ports           # Show open ports
myip            # Show IP addresses
weather         # Weather in London
```

---

##  Custom Tools

This setup uses custom-built binaries in `/usr/local/bin` for:

- **kubectl** - Kubernetes CLI
- **helm** - Kubernetes package manager  
- **flux** - GitOps toolkit
- **oras** - OCI registry client
- **cosign** - Container signing/verification
- **skopeo** - Container image operations
- **jq** - JSON processor

All tools have auto-completion configured with absolute paths to ensure the custom builds are used.

---

##  Configuration Highlights

### Optimized Loading Order
```
.bashrc
  ↓
  ├─→ .bashrc-developer    (env vars, functions)
  ├─→ .bash_aliases         (general aliases)
  ├─→ .bash_aliases_ai      (AI/GPU aliases)  
  └─→ .bash_completions_extras (after aliases exist)
```

### PATH Priority
```
$HOME/.local/bin
$HOME/bin
/usr/local/bin    ← Custom tools guaranteed priority
/usr/bin
/bin
...
```

### Smart Completions
- Uses absolute paths: `/usr/local/bin/kubectl` not `kubectl`
- Completions attached to aliases (k, kg, kd)
- Error handling to prevent startup noise
- Lazy-loaded for performance

---

##  Updating Configuration

### Pull Latest Changes
```bash
cd ~/DevOps/dotfiles
git pull
source ~/.bashrc  # Changes apply immediately via symlinks
```

### After Local Edits
```bash
cd ~/DevOps/dotfiles
git add .
git commit -m "Update configuration"
git push
```

### Benefits of Symlink Approach
- ✅ Edit files in `~/DevOps/dotfiles/` → changes take effect immediately
- ✅ `git pull` → automatic updates everywhere
- ✅ Version controlled configuration
- ✅ Easy to rollback via git

---

##  Testing & Verification

### Verify Installation
```bash
# Test completions
k get <TAB><TAB>          # Should show resource types
k get pods -n <TAB><TAB>   # Should show namespaces
helm <TAB><TAB>            # Should show helm commands

# Verify PATH
echo $PATH | tr ':' '\n' | head -5
which kubectl              # Should be /usr/local/bin/kubectl

# Test functions
kctxs                      # Show contexts
ai_backend                 # Detect GPU

# Test vim
vim test.txt
# Should see line numbers
# Ctrl+C/V should work for clipboard
```

### Check for Issues
```bash
# No syntax errors
bash -n ~/.bashrc
bash -n ~/.bash_aliases

# Check completion function exists  
type __start_kubectl

# Verify no duplicates in loading
source ~/.bashrc
# Should see each message only ONCE
```

---

##  Best Practices

### Security
- Never commit kubeconfig files
- Keep API keys out of git
- Use `.gitignore_global` for sensitive patterns
- Separate work/personal configs if needed

### Maintenance
- Review and update custom tools quarterly
- Test in non-production before committing
- Keep documentation in sync with changes
- Use descriptive commit messages

### Performance
- Lazy-load completions (don't slow shell startup)
- Use absolute paths for custom binaries
- Minimize redundant sourcing

---

##  Customization

### Work vs Personal
Create work-specific overrides:
```bash
# ~/.gitconfig-work (not in repo)
[user]
    email = work@company.com

# Add to .gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

### Additional Aliases
Add to appropriate file:
- General system aliases → `.bash_aliases`
- Development functions → `.bashrc-developer`
- AI/GPU specific → `.bash_aliases_ai`

---

##  System Requirements

- **OS**: Debian 11+, Ubuntu 22.04+, Linux Mint 21+
- **Shell**: bash 4.0+
- **Tools**: git, gh (GitHub CLI), xclip (for vim clipboard)
- **Optional**: nerdctl, kubectl, helm, flux (if using those features)

---

##  Troubleshooting

### Completions Not Working
```bash
# Verify function exists
type __start_kubectl

# Check completions are set
complete -p | grep kubectl

# Manually reload
source ~/.bash_completions_extras
```

### PATH Issues
```bash
# Check order
echo $PATH | tr ':' '\n'

# Verify /usr/local/bin is early
which kubectl
```

### Duplicate Messages
```bash
# Should not happen with optimized config
# If it does, check for manual sourcing in other files
grep -r "bash_aliases" ~/
```

---

##  Notes

- **Editor**: `vi` / `vim`
- **Target systems**: Debian / Ubuntu / Linux Mint
- **Authentication**: GitHub CLI (`gh`) for personal account
- **Repository**: Private
- **Philosophy**: Modular, optimized, version-controlled

---

##  Acknowledgments

Configuration optimized with best practices from:
- Kubernetes SIG-CLI
- Cloud Native Computing Foundation (CNCF)
- The dotfiles community

---

**License:** Personal use / MIT  
**Author:** Martin Stadler  
**Contact:** martin@sansnom.co.uk  
**Last Updated:** October 2025

---

*"Configuration as code - because your shell environment matters."* 🐧✨
