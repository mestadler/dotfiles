# ===========================================
# ~/.bashrc — Debian Base + Developer Setup
# Martin Stadler (mestadler)
# ===========================================

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# --- History configuration ---
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000

# --- Window size check ---
shopt -s checkwinsize

# --- chroot awareness ---
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# --- Prompt setup ---
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# --- XTerm window title ---
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# --- Colour support for ls/grep ---
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
fi

# --- ls aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# --- Useful defaults ---
alias vi='vim'
alias cls='clear'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias rm='rm -i'

# ===========================================
# PATH Configuration
# ===========================================
# Ensure custom binaries take precedence over system ones
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# ===========================================
# Base Completion System
# ===========================================
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ===========================================
# Load User Configuration (Order Matters!)
# ===========================================

# 1. Developer profile (environment variables, functions)
[ -f "$HOME/.bashrc-developer" ] && source "$HOME/.bashrc-developer"

# 2. Aliases (must load BEFORE completions)
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
[ -f "$HOME/.bash_aliases_ai" ] && . "$HOME/.bash_aliases_ai"

# 3. Extra completions (must load AFTER aliases)
[ -f "$HOME/.bash_completions_extras" ] && source "$HOME/.bash_completions_extras"

# ===========================================
# Final Greeting
# ===========================================
echo "👋 Bash environment loaded for $(whoami) — $(hostname)"
