#!/bin/zsh
# yoga-files v2.0 - Aliases Modernos

# Navegação (mantidos por nostalgia ❤️)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# bash does not support some alias names (like '~' or '-')
if [ -n "${ZSH_VERSION-}" ]; then
  alias ~='cd ~'
  alias -- -='cd -'
fi

# Listagem aprimorada
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsd='ls -lahF'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'

# npm/Node.js
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrs='npm run start'
alias nrw='npm run watch'

# TypeScript
alias tsc='npx tsc'
alias tsx='npx tsx'
alias tsw='npx tsc --watch'
alias tsinit='npx tsc --init'

# Desenvolvimento JavaScript/TypeScript
alias dev='npm run dev'
alias build='npm run build'
alias test='npm run test'
alias lint='npm run lint'
alias format='npm run format'
alias start='npm run start'
alias watch='npm run watch'

# Yoga commands
alias yoga='yoga_dashboard'
alias yogi='yoga_dashboard'
alias flow='yoga_flow'
alias breathe='yoga_breath'
alias pose='yoga_pose'
alias namaste='echo "🧘 Namastê, yogi!"'

# AI commands
alias ai='yoga-ai'
alias yai='yoga-ai'
alias ai-chat='yoga-ai chat'
alias ai-code='yoga-ai code'
alias ai-help='yoga-ai help'
alias ai-fix='yoga-ai fix'
alias ai-explain='yoga-ai explain'
alias ai-debug='yoga-ai debug'

# Editor
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
alias code='nvim'

# ASDF
alias asdf-list='asdf list'
alias asdf-current='asdf current'
alias asdf-global='asdf global'
alias asdf-local='asdf local'
alias asdf-install='asdf install'
alias asdf-uninstall='asdf uninstall'
alias asdf-plugin='asdf plugin'
alias asdf-update='asdf update && asdf plugin update --all'

# Sistema
alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias yogarc='nvim ~/.yoga/config.yaml'
alias path='echo $PATH | tr ":" "\n"'
ports() {
  if command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP -sTCP:LISTEN
    return 0
  fi

  if command -v netstat >/dev/null 2>&1; then
    # macOS netstat doesn't support -p; Linux often does.
    netstat -an 2>/dev/null | grep LISTEN || true
    return 0
  fi

  echo "ports: missing lsof/netstat" >&2
  return 1
}

# Docker (se instalado)
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'

# Utilidades
alias weather='curl wttr.in'
alias myip='curl ipecho.net/plain'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
serve() {
  local port="${1:-8000}"

  if command -v python3 >/dev/null 2>&1; then
    python3 -m http.server "$port"
    return 0
  fi

  if command -v python >/dev/null 2>&1; then
    python -m http.server "$port"
    return 0
  fi

  echo "serve: missing python3/python" >&2
  return 1
}
alias json='python -m json.tool'

# Clipboard (cross-platform)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS já tem pbcopy/pbpaste
    :
elif command -v xclip &>/dev/null; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
elif command -v xsel &>/dev/null; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

# Funções úteis como aliases
alias mkcd='function _mkcd(){ mkdir -p "$1" && cd "$1"; }; _mkcd'
alias extract='function _extract(){ tar -xvf "$1"; }; _extract'
alias search='function _search(){ grep -r "$1" .; }; _search'
alias find-file='function _ff(){ find . -name "*$1*"; }; _ff'
alias find-text='function _ft(){ grep -r "$1" . --include="*.$2"; }; _ft'

# Projetos rápidos
alias projects='cd ~/code'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop'
alias yoga-home='cd ~/.yoga'

# Performance
alias top='htop'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Segurança
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Fun
alias matrix='cmatrix'
alias sl='sl'
alias fortune='fortune'
