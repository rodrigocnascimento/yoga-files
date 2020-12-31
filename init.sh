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
ssh_agent_run "bitbucket"

export FZF_DEFAULT_OPTS='--height 40% --border --pointer=👉'

export MYVIMRC=$YOGA_HOME/core/terminal/vimrc
export VIMINIT='source $MYVIMRC'

# check for updates
if [[ -d "$YOGA_HOME" ]]; then
  yoga_warn "ROUND 2 ... UPDATING!" && update_yoga
fi
