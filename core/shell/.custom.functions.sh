#!/bin/zsh

pid_port () {
        echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

kill_port () {
  if [[ $(pid_port $1) -ne "" ]]
  then
      kill -9 $(pid_port "$1")
  fi
}

# abre/reatacha a sessão tmux (nome opcional; default: work)
sshc() {
  local s="${1:-work}"
  ssh ssh-casa "tmux new -As ${s}"
}

# Aliases úteis para o RAG
rag() {
  if [ -z "$1" ]; then
    # Se não passar caminho, usa diretório atual
    ~/rag-server/start.sh --path "$(pwd)"
  else
    # Se passar caminho, usa o caminho fornecido
    ~/rag-server/start.sh --path "$1"
  fi
}

# No seu .zshrc, substitua por:
rag-reindex() {
  echo "🔄 Reindexando código..."
  curl -s -X POST http://localhost:8000/reindex | python3 -m json.tool
  echo "✅ Reindexação concluída!"
}

# Função para matar o servidor se precisar
rag-stop() {
  pkill -f "python rag_server.py"
  echo "🛑 Servidor RAG parado"
}

# Função para verificar se está rodando
rag-check() {
  if curl -s http://localhost:8000/info > /dev/null; then
    echo "✅ Servidor RAG está rodando"
    rag-status
  else
    echo "❌ Servidor RAG não está rodando"
    echo "   Inicie com: rag --path /caminho/do/projeto"
  fi
}

aliases() {
  local selected name

  selected=$(
    (alias | sed 's/^alias //'; functions | grep '()') \
    | fzf \
      --prompt="Aliases & Functions > " \
      --preview='echo {}' \
      --preview-window=down:3:wrap
  )

  [[ -z "$selected" ]] && return

  name="${selected%%=*}"
  name="${name%%()*}"

  echo "➡️ Executando: $name"
  eval "$name"
}

cc() {
  local selected key line type label cmd

  # 1. Captura a saída. 
  # Se o separador for REALMENTE o pipe '|', precisamos garantir que o awk entenda.
  selected=$(cc_data | awk -F'|' 'NF==3 {print $1"|"$2"|"$3}' | fzf \
    --prompt="🚀 Command Center > " \
    --height=90% \
    --layout=reverse \
    --border \
    --delimiter='\|' \
    --with-nth=2 \
    --preview 'echo {3}' \
    --preview-window=down:3:wrap \
    --expect=enter,ctrl-y,ctrl-e,ctrl-x)

  [ -z "$selected" ] && return

  # 2. Extração da tecla e da linha
  key=$(head -1 <<< "$selected")
  line=$(sed -n '2p' <<< "$selected")

  [ -z "$line" ] && return

  # 3. Parsing usando o pipe como separador
  # O segredo aqui é o IFS='|'
  IFS='|' read -r type label cmd <<< "$line"

  # 4. Ações
  case "$key" in
    ctrl-y) echo -n "$cmd" | pbcopy; echo "📋 Copiado!";;
    ctrl-e) nvim "$cmd";;
    ctrl-x) cc_action "$type" "$cmd";;
    *) 
      # Se for o enter ou tecla vazia
      if [[ -n "$cmd" ]]; then
        echo "🚀 Executando: $cmd"
        # Se for um alias de 'cd', o eval roda no subshell da função, 
        # para funcionar no SEU shell atual, a função cc precisa ser um alias ou source.
        eval "$cmd"
      fi
      ;;
  esac
}

cc_data() {
  # ⭐ FAVORITOS
  if [[ -f ~/.cc_favorites ]]; then
    while IFS= read -r line; do
      echo "FAV|$line|$line"
    done < ~/.cc_favorites
  fi

  # ⚡ ALIASES (zsh-safe)
  alias | while IFS= read -r line; do
    name="${line%%=*}"
    name="${name#alias }"
    cmd="${line#*=}"
    cmd="${cmd#\'}"
    cmd="${cmd%\'}"

    [[ -n "$name" && -n "$cmd" ]] && echo "ALIAS|$name|$cmd"
  done

  # 🔧 FUNCTIONS (zsh correto)
  for fn in ${(k)functions}; do
    echo "FUNC|$fn|$fn"
  done

  # 🌿 GIT
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git branch --format='%(refname:short)' | while read -r b; do
      echo "BRANCH|$b|$b"
    done
  fi

  # 🐳 DOCKER
  docker ps --format '{{.Names}}' 2>/dev/null | while read -r c; do
    echo "DOCKER|$c|$c"
  done

  # 📜 SCRIPTS (fix permissão macOS)
  fd . . -t f -perm -111 2>/dev/null | while read -r f; do
    echo "SCRIPT|$f|$f"
  done

  # 🧠 HISTORY (zsh-safe)
  fc -rl 1 | sed 's/^[0-9]* *//' | sort | uniq -c | sort -nr | awk '{$1=""; print substr($0,2)}' | while read -r h; do
    echo "HIST|$h|$h"
  done
}

cc_preview() {
  IFS='|' read -r type label cmd <<< "$1"

  case "$type" in
    ALIAS)
      echo "$cmd"
      ;;
    FUNC)
      type "$cmd"
      ;;
    BRANCH)
      git log --oneline -n 10 "$cmd" 2>/dev/null
      ;;
    DOCKER)
      docker logs --tail 20 "$cmd" 2>/dev/null
      ;;
    SCRIPT)
      bat "$cmd" 2>/dev/null || cat "$cmd"
      ;;
    HIST)
      echo "$cmd"
      ;;
  esac
}

cc_action() {
  local type="$1"
  local cmd="$2"

  case "$type" in
    BRANCH)
      git checkout "$cmd"
      ;;
    DOCKER)
      docker exec -it "$cmd" sh
      ;;
    SCRIPT)
      chmod +x "$cmd" && "$cmd"
      ;;
    *)
      eval "$cmd"
      ;;
  esac
}

ccp() {
  local dir
  dir=$(fd . ~/code -t d -d 2 | fzf \
    --prompt="📂 Projetos > " \
    --preview='eza --tree --level=2 {} 2>/dev/null')

  [[ -z "$dir" ]] && return

  local name=$(basename "$dir")

  if ! tmux has-session -t "$name" 2>/dev/null; then
    tmux new-session -ds "$name" -c "$dir"
  fi

  tmux switch-client -t "$name"
}

