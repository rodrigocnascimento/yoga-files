#!/bin/zsh

DIR="$(dirname "$(readlink -f "$0")")"

# Carrega os arquivos de ambiente
source $DIR/core/aliases.sh
source $DIR/core/functions.sh

# Adicionar a chamada do Tempo para SP
# curl "http://wttr.in/São Paulo"

# Load custom aliases
[ -f ~/.custom.aliases ] && source ~/.custom.aliases

# Load custom functions
[ -f ~/.custom.functions ] && source ~/.custom.functions


# yoga ssh function to connect to github
ssh_agent_run "github"

export FZF_DEFAULT_OPTS='--height 40% --border --pointer=👉'

# check for updates
if [[ -d "$HOME/.yoga" ]]; then
   local UPSTREAM=${1:-'@{u}'}
   local LOCAL=$(git -C  $HOME/.yoga rev-parse @)
   local REMOTE=$(git -C $HOME/.yoga rev-parse "$UPSTREAM")
   local BASE=$(git -C $HOME/.yoga merge-base @ "$UPSTREAM")

   if [ $LOCAL = $REMOTE ]; then
      yoga_action "update_yoga" "Up-to-date"
   elif [ $LOCAL = $BASE ]; then
      yoga_action "update_yoga" "Need to pull"
      yoga_warn "ROUND 2 ... UPDATING!"
      git pull --rebase

      sh $HOME/.yoga/install.sh
   elif [ $REMOTE = $BASE ]; then
      yoga_action "update_yoga" "Need to push"
   else
      yoga_fail "Repository diverged!"
   fi
fi
