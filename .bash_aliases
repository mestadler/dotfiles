# ===========================================
# ~/.bash_aliases — Common Aliases
# Martin Stadler (mestadler)
# ===========================================

# --- Core system helpers ---
alias cls='clear'
alias vi='vim'
alias ..='cd ..'
alias ...='cd ../..'
alias h='history'
alias j='jobs -l'

# --- Listing and navigation ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls --human-readable --size -1 -S --classify'

# --- Disk and memory usage ---
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias meminfo='grep -E "Mem|Cache|Swap" /proc/meminfo'

# --- Grep / search ---
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias findbig='sudo find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null | sort -k 5 -h'

# --- Safety ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Networking ---
alias ports='sudo netstat -tulanp'
alias myip='ip addr show | grep "inet " | grep -v 127.0.0.1'
alias pingg='ping -c 4 8.8.8.8'
alias digg='dig +short myip.opendns.com @resolver1.opendns.com'

# ==================================================
# Container Tools — nerdctl (containerd) primary
# ==================================================

alias nc='nerdctl'
alias ncl='nerdctl ps -a'
alias ncr='nerdctl run --rm -it'
alias nce='nerdctl exec -it'
alias nci='nerdctl images'
alias nclog='nerdctl logs -f'
alias nck='nerdctl kill'
alias ncrm='nerdctl rm'
alias ncrmi='nerdctl rmi'
alias ncpull='nerdctl pull'
alias ncpush='nerdctl push'
alias nctag='nerdctl tag'
alias ncinspect='nerdctl inspect'

# --- Compose (nerdctl compose) ---
alias ncu='nerdctl compose up -d'
alias ncd='nerdctl compose down'
alias ncrb='nerdctl compose restart'
alias nclogs='nerdctl compose logs -f --tail=100'

# --- Build / Registry ---
alias ncb='nerdctl build'
alias ncbt='nerdctl build --progress=plain --no-cache'
alias ncls='nerdctl login'
alias nclo='nerdctl logout'

# --- Volumes / Networks ---
alias ncv='nerdctl volume ls'
alias ncvrm='nerdctl volume rm'
alias ncn='nerdctl network ls'
alias ncnrm='nerdctl network rm'

# --- System and cleanup ---
alias ncstats='nerdctl stats'
alias nctop='nerdctl top'
alias ncinfo='nerdctl info'
alias ncpause='nerdctl pause'
alias ncunpause='nerdctl unpause'
alias ncrestart='nerdctl restart'

alias ncclean='nerdctl system prune -af'
alias nccleanv='nerdctl volume prune -f'
alias nccleani='nerdctl image prune -af'
alias nccleanall='nerdctl system prune -af --volumes'

# --- Docker compatibility aliases (point to nerdctl) ---
alias docker='nerdctl'
alias d='nerdctl'
alias dps='nerdctl ps -a'
alias di='nerdctl images'
alias drun='nerdctl run --rm -it'
alias dstop='nerdctl stop'
alias drm='nerdctl rm'
alias dclean='nerdctl system prune -af --volumes'

# ==================================================
# Kubernetes (kubectl) — general convenience
# ==================================================
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods -A'
alias kgs='kubectl get svc -A'
alias kgn='kubectl get nodes'
alias kl='kubectl logs -f'
alias ke='kubectl exec -it'
alias kd='kubectl describe'
alias kctx='kubectl config get-contexts'
alias kns='kubectl config set-context --current --namespace'

# ==================================================
# Git Shortcuts
# ==================================================
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate --all'
alias gc='git commit -v'
alias gp='git push'
alias gpl='git pull --rebase'
alias gco='git checkout'
alias gb='git branch -vv'
alias gd='git diff'

# ==================================================
# Package Management
# ==================================================
alias aptu='sudo apt update && sudo apt upgrade -y'
alias apti='sudo apt install -y'
alias aptr='sudo apt autoremove -y'
alias rebootf='sudo systemctl reboot -i'

# ==================================================
# Utilities
# ==================================================
alias serve='python3 -m http.server 8080'
alias weather='curl -s wttr.in/London'
alias ipinfo='curl -s ipinfo.io | jq'

# --- Custom message ---
echo "🐋 Aliases loaded"
