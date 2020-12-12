#!/bin/zsh

DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/../common.sh"

# Carrega os arquivos de ambiente
source $YOGA_HOME/.aliases
source $YOGA_HOME/.functions

# Adicionar a chamada do Tempo para SP
curl "http://wttr.in/São Paulo"

# Load custom aliases
if [ -f ~/.custom.aliases.sh ]; then
  source ~/.custom.aliases.sh
fi

# Load custom functions
if [ -f ~/.custom.functions.sh ]; then
  source ~/.custom.functions.sh
fi