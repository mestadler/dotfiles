# 🔧 Functions Reference

Complete list of custom functions available in your dotfiles.

---

## 📦 Kubernetes Functions

### `kctxs`
**Show current Kubernetes context and all available contexts**

```bash
# Usage
kctxs

# Output:
# Current context:
# docker-desktop
#
# Available contexts:
# CURRENT   NAME              CLUSTER           AUTHINFO
# *         docker-desktop    docker-desktop    docker-desktop
#           prod-cluster      prod-cluster      prod-user
#           dev-cluster       dev-cluster       dev-user
```

**Source:** `.bashrc-developer`

---

### `kn [namespace]`
**Show or switch current namespace**

```bash
# Show current namespace
kn
# Output: default

# Switch to different namespace
kn kube-system
# Output: Context "current-context" modified.

# Common usage
kn monitoring    # Switch to monitoring namespace
kn              # Check which namespace you're in
```

**Source:** `.bashrc-developer`

---

### `klog <pod-prefix> [namespace]`
**Quick logs for first pod matching prefix**

```bash
# Get logs from first pod matching "nginx"
klog nginx

# Get logs from specific namespace
klog nginx default

# Get logs from all namespaces
klog nginx --all-namespaces

# Example with common patterns
klog api          # Find api-* pod and tail logs
klog postgres     # Find postgres pod logs
klog ingress -n ingress-nginx
```

**Source:** `.bashrc-developer`

---

## 🐙 GitHub Functions

### `gh_clone <owner/repo>`
**Clone a GitHub repo and cd into it**

```bash
# Clone and enter directory in one command
gh_clone kubernetes/kubernetes
# Clones repo and automatically: cd kubernetes

gh_clone mestadler/my-project
# Clones and enters my-project directory

# Saves you from doing:
# gh repo clone owner/repo
# cd repo
```

**Source:** `.bashrc-developer`

---

### `gh_create_repo <repo-name>`
**Create a private GitHub repo and push current directory**

```bash
# From existing project directory
cd ~/my-new-project
git init
git add .
git commit -m "Initial commit"
gh_create_repo my-new-project

# Creates private repo on GitHub and pushes current code

# Options:
# - Creates private repo by default
# - Uses current directory as source
# - Pushes to GitHub automatically
```

**Source:** `.bashrc-developer`

---

## 🐋 Docker/Container Functions

### `dcleanall`
**Stop all containers and clean everything**

```bash
# Stop all running containers and prune everything
dcleanall

# Output:
# 🧹 Cleaning all Docker resources...
# [stops all containers]
# [removes containers, images, volumes, networks]

# WARNING: This is destructive! Use with caution.
# Good for: cleaning up development environments
# Bad for: production systems
```

**Source:** `.bashrc-developer`

---

## 🤖 AI/GPU Functions

### `ai_backend`
**Detect GPU backend (CUDA vs ROCm)**

```bash
# Check which GPU system you have
ai_backend

# Possible outputs:
# CUDA/NVIDIA
# ROCm/AMD  
# CPU/No GPU tools detected

# Use in scripts
if ai_backend | grep -q NVIDIA; then
  echo "Running NVIDIA setup"
fi
```

**Source:** `.bash_aliases_ai`

---

### `gpuinfo`
**Show comprehensive GPU information**

```bash
# Display all GPU info available
gpuinfo

# Shows:
# - nvidia-smi output (if NVIDIA)
# - rocm-smi output (if AMD)
# - lspci GPU listing

# Example output (NVIDIA):
# +-----------------------------------------------------------------------------+
# | NVIDIA-SMI 535.xx.xx    Driver Version: 535.xx.xx    CUDA Version: 12.2   |
# |-------------------------------+----------------------+----------------------+
# | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
# ...
```

**Source:** `.bash_aliases_ai`

---

### `ptinfo`
**Show PyTorch configuration and GPU availability**

```bash
# Check PyTorch installation and GPU access
ptinfo

# Output example:
# python: 3.10.12
# torch: 2.1.0
# cuda build: 12.1 available: True
# hip build: None
# num cuda devices: 1
# cuda device 0: NVIDIA GeForce RTX 3080

# Great for debugging:
# - PyTorch installation
# - CUDA availability
# - GPU detection
```

**Source:** `.bash_aliases_ai`

---

### `ptgpu`
**Show PyTorch GPU device name**

```bash
# Quick check of GPU name from PyTorch
ptgpu

# Output:
# NVIDIA GeForce RTX 3080
# or
# CUDA not available
```

**Source:** `.bash_aliases_ai`

---

### `pthip`
**Show ROCm information for AMD GPUs**

```bash
# Check ROCm installation and availability
pthip

# Output:
# rocminfo: True
# [rocminfo detailed output]

# Useful for AMD GPU debugging
```

**Source:** `.bash_aliases_ai`

---

### `nvver`
**Show NVIDIA driver and CUDA versions**

```bash
# Quick NVIDIA version check
nvver

# Output:
# NVIDIA GeForce RTX 3080, 535.xx.xx, 12.2

# Shows: GPU Name, Driver Version, CUDA Version
```

**Source:** `.bash_aliases_ai`

---

### `rocmver`
**Show ROCm version and GPU info**

```bash
# Quick ROCm version check
rocmver

# Output:
# [Product name and driver version from rocm-smi]
```

**Source:** `.bash_aliases_ai`

---

## 🐍 Python Environment Functions

### `mkvenv [name]`
**Create and activate Python virtual environment**

```bash
# Create default venv (.venv)
mkvenv

# Create named venv
mkvenv myproject-env

# What it does:
# 1. python3 -m venv <name>
# 2. Activates the environment
# 3. Upgrades pip and installs wheel

# After running, you're in the venv:
# (.venv) martin@gmk:~/project$
```

**Source:** `.bash_aliases_ai`

---

### `workon [name]`
**Activate existing virtual environment**

```bash
# Activate default venv
workon

# Activate named venv
workon myproject-env

# Common workflow:
mkvenv              # First time: create venv
workon              # Later: just activate it

# Deactivate with:
deactivate
```

**Source:** `.bash_aliases_ai`

---

## 🚢 GPU Container Functions

### `ncnv <image> [args...]`
**Run NVIDIA GPU container with nerdctl**

```bash
# Run NVIDIA PyTorch container
ncnv nvcr.io/nvidia/pytorch:24.08-py3 bash

# What it does:
# - Adds --gpus all
# - Mounts HuggingFace cache
# - Sets up IPC and memory limits
# - Runs interactively

# Inside container, GPU is available:
# nvidia-smi
# python -c "import torch; print(torch.cuda.is_available())"
```

**Source:** `.bash_aliases_ai`

---

### `ncrocm <image> [args...]`
**Run AMD ROCm container with nerdctl**

```bash
# Run ROCm PyTorch container
ncrocm rocm/pytorch:latest bash

# What it does:
# - Mounts /dev/kfd and /dev/dri
# - Adds to video group
# - Mounts HuggingFace cache
# - Sets up IPC and security options

# Inside container, ROCm is available:
# rocm-smi
# python -c "import torch; print(torch.cuda.is_available())"
```

**Source:** `.bash_aliases_ai`

---

### `ncaigpu <image> [args...]`
**Auto-detect GPU and run appropriate container**

```bash
# Automatically chooses NVIDIA or AMD setup
ncaigpu pytorch/pytorch:latest bash

# What it does:
# 1. Detects GPU backend (ai_backend)
# 2. If NVIDIA: runs ncnv
# 3. If AMD: runs ncrocm  
# 4. If no GPU: runs regular container

# Perfect for scripts that work on both GPU types!

# Example - run Jupyter
ncaigpu jupyter/pytorch-notebook:latest
```

**Source:** `.bash_aliases_ai`

---

### `ai_cache_args`
**Generate cache mount arguments for containers**

```bash
# Used internally by container functions
# Returns: -v $HF_HOME:$HF_HOME -e HF_HOME -e TRANSFORMERS_CACHE -e HF_DATASETS_CACHE

# Can use directly:
nerdctl run $(ai_cache_args) my-image

# Ensures HuggingFace models aren't re-downloaded each time
```

**Source:** `.bash_aliases_ai`

---

## 📊 Function Summary Table

| Function | Purpose | Source File |
|----------|---------|-------------|
| `kctxs` | Show k8s contexts | .bashrc-developer |
| `kn [ns]` | Switch/show namespace | .bashrc-developer |
| `klog <pod>` | Quick pod logs | .bashrc-developer |
| `gh_clone` | Clone and cd | .bashrc-developer |
| `gh_create_repo` | Create repo | .bashrc-developer |
| `dcleanall` | Docker cleanup | .bashrc-developer |
| `ai_backend` | Detect GPU type | .bash_aliases_ai |
| `gpuinfo` | Show GPU info | .bash_aliases_ai |
| `ptinfo` | PyTorch config | .bash_aliases_ai |
| `ptgpu` | PyTorch GPU name | .bash_aliases_ai |
| `pthip` | ROCm info | .bash_aliases_ai |
| `nvver` | NVIDIA versions | .bash_aliases_ai |
| `rocmver` | ROCm versions | .bash_aliases_ai |
| `mkvenv` | Create Python venv | .bash_aliases_ai |
| `workon` | Activate venv | .bash_aliases_ai |
| `ncnv` | NVIDIA container | .bash_aliases_ai |
| `ncrocm` | AMD container | .bash_aliases_ai |
| `ncaigpu` | Auto GPU container | .bash_aliases_ai |
| `ai_cache_args` | Cache mount args | .bash_aliases_ai |

---

## 🎯 Common Workflows

### Starting a New Project
```bash
# 1. Create directory
mkdir ~/projects/my-app && cd ~/projects/my-app

# 2. Create Python environment
mkvenv

# 3. Install dependencies
pip install -r requirements.txt

# 4. Start working
code .
```

### Testing PyTorch/GPU Setup
```bash
# 1. Check GPU backend
ai_backend

# 2. Check PyTorch
ptinfo

# 3. Test in container
ncaigpu pytorch/pytorch:latest python -c "import torch; print(torch.cuda.is_available())"
```

### Kubernetes Troubleshooting
```bash
# 1. Check current context
kctxs

# 2. Switch namespace if needed
kn production

# 3. Get logs from problem pod
klog api-deployment

# 4. Describe the pod
kd pod $(kg pods | grep api | head -1 | awk '{print $1}')
```

### GitHub Workflow
```bash
# Clone and start working
gh_clone user/repo
# Automatically in repo directory

# Create new repo from current project
git init
git add .
git commit -m "Initial commit"
gh_create_repo my-new-project
```

---

## 💡 Pro Tips

### Combine Functions with Aliases
```bash
# Switch namespace and check pods
kn monitoring && kgp

# Clone and open in editor
gh_clone user/repo && code .

# Create venv and install deps
mkvenv && pip install -r requirements.txt
```

### Use in Scripts
```bash
#!/bin/bash
# Example script

if ! ai_backend | grep -q NVIDIA; then
  echo "This script requires NVIDIA GPU"
  exit 1
fi

mkvenv training-env
pip install torch torchvision
python train.py
```

### Check Function Definitions
```bash
# See exactly what a function does
type kctxs
type ncaigpu

# See all functions
declare -F | grep -v "^declare -f _"
```

---

## 🔍 Troubleshooting

### Function Not Found
```bash
# Make sure dotfiles are loaded
source ~/.bashrc

# Check which file defines it
grep -r "function_name" ~/DevOps/dotfiles/

# Verify file is sourced
grep "bash_aliases_ai" ~/.bashrc
```

### Function Not Working
```bash
# Check for syntax errors
bash -n ~/.bashrc-developer
bash -n ~/.bash_aliases_ai

# Test function directly
bash -x -c "source ~/.bashrc; kctxs"
```

---

Type `type <function-name>` to see exactly what any function does.
