#!/bin/bash

# Carrega os arquivos de ambiente
source ~/.yoga/.aliases
source ~/.yoga/.functions
source ~/.yoga/.bash_ps1

# Load custom aliases
if [ -f ~/.custom.aliases.sh ]; then
  source ~/.custom.aliases.sh
fi

# Load custom functions
if [ -f ~/.custom.functions.sh ]; then
  source ~/.custom.functions.sh
fi

ssh_agent_run rodrigo.nascimento