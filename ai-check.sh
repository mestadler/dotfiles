#!/usr/bin/env bash
# ===========================================
# ai-check.sh — Local AI / GPU sanity checks
# Martin Stadler (mestadler)
# Targets: NVIDIA (RTX 4090), AMD ROCm (Strix Halo 395+)
# ===========================================
set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

title() { printf "\n\033[1;36m== %s ==\033[0m\n" "$*"; }
ok()    { printf "\033[1;32m✔ %s\033[0m\n" "$*"; }
warn()  { printf "\033[1;33m⚠ %s\033[0m\n" "$*"; }
err()   { printf "\033[1;31m✘ %s\033[0m\n" "$*"; }

title "Host summary"
have lscpu && lscpu | sed -n '1,6p' || true
echo
have lspci && lspci | egrep -i 'vga|3d|display' || true

# Detect Strix Halo (helpful hinting only)
if have lscpu && lscpu | grep -qi 'strix'; then
  ok "Strix Halo detected (Ryzen AI Max+/395+ family). ROCm/HIP path likely."
fi

title "Environment / caches"
echo "HF_HOME=${HF_HOME:-$HOME/.cache/huggingface}"
echo "TRANSFORMERS_CACHE=${TRANSFORMERS_CACHE:-$HOME/.cache/huggingface/transformers}"
echo "HF_DATASETS_CACHE=${HF_DATASETS_CACHE:-$HOME/.cache/huggingface/datasets}"
echo "CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES-<unset>}"
echo "HIP_VISIBLE_DEVICES=${HIP_VISIBLE_DEVICES-<unset>}"

title "GPU tools"
if have nvidia-smi; then
  nvidia-smi || warn "nvidia-smi failed"
else
  warn "nvidia-smi not found (skip NVIDIA host check)"
fi

if have rocm-smi; then
  rocm-smi || warn "rocm-smi failed"
elif have rocminfo; then
  rocminfo | head -n 30 || warn "rocminfo failed"
else
  warn "rocm-smi/rocminfo not found (skip AMD host check)"
fi

title "PyTorch backend"
python3 - <<'PY' || { echo "python torch check failed"; exit 1; }
import sys, platform
print("python:", sys.version.split()[0])
try:
    import torch
except Exception as e:
    print("torch: NOT INSTALLED:", e); raise SystemExit(0)

print("torch:", torch.__version__)
print("cuda build:", getattr(torch.version, "cuda", None))
print("hip build:", getattr(torch.version, "hip", None))
print("cuda available:", torch.cuda.is_available())
print("num cuda devices:", torch.cuda.device_count() if torch.cuda.is_available() else 0)
if torch.cuda.is_available():
    try:
        print("cuda device 0:", torch.cuda.get_device_name(0))
    except Exception as e:
        print("cuda device name error:", e)

# HIP probe (does not guarantee full ROCm runtime availability)
try:
    import subprocess
    r = subprocess.run(["rocminfo"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=5)
    print("rocminfo exit:", r.returncode)
except FileNotFoundError:
    print("rocminfo: not found")
except Exception as e:
    print("rocminfo error:", e)
PY

title "HF tiny model smoke (optional, skips if offline)"
python3 - <<'PY'
import os, socket
def online():
    try:
        socket.create_connection(("huggingface.co", 443), 2).close(); return True
    except: return False

if not online():
    print("offline or blocked — skipping HF smoke"); raise SystemExit(0)

os.environ.setdefault("HF_HUB_ENABLE_HF_TRANSFER", "1")
model_id = "sshleifer/tiny-gpt2"
try:
    from transformers import AutoTokenizer, AutoModelForCausalLM
    tok = AutoTokenizer.from_pretrained(model_id)
    mdl = AutoModelForCausalLM.from_pretrained(model_id)
    print("HF tiny model OK:", model_id)
except Exception as e:
    print("HF tiny model FAILED:", e)
PY

title "Container checks (nerdctl)"
if have nerdctl; then
  ok "nerdctl present: $(nerdctl --version | head -n1)"

  # NVIDIA container test (requires nvidia runtime configured for containerd)
  if have nvidia-smi; then
    echo "NVIDIA container smoke (may pull ~small image, can skip if air-gapped):"
    if nerdctl run --rm --gpus all nvidia/cuda:12.5.0-base-ubuntu24.04 nvidia-smi >/dev/null 2>&1; then
      ok "NVIDIA container run OK"
    else
      warn "NVIDIA container run failed (runtime not wired or no network?)"
    fi
  fi

  # ROCm container test (map kfd/dri)
  if have rocm-smi || have rocminfo; then
    echo "ROCm container smoke (may pull image; requires /dev/kfd & /dev/dri perms):"
    if nerdctl run --rm --device /dev/kfd --device /dev/dri --group-add video --ipc=host --security-opt seccomp=unconfined rocm/dev-ubuntu-24.04:6.2.4 bash -lc 'rocminfo >/dev/null 2>&1 || rocm-smi >/dev/null 2>&1' >/dev/null 2>&1; then
      ok "ROCm container run OK"
    else
      warn "ROCm container run failed (devices/permissions/network?)"
    fi
  fi
else
  warn "nerdctl not found — skipping container tests"
fi

title "Summary"
ok "Checks completed"
echo "Tip: nvsmi / rocmsmi / gpuinfo / ptinfo / ncrocm / ncnv (see .bash_aliases_ai)"

