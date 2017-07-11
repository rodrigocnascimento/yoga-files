#!/bin/bash

# Carrega os arquivos de ambiente
source ~/.yoga/.aliases
source ~/.yoga/.functions
source ~/.yoga/.envvars
source ~/.yoga/.ps1
source ~/.yoga/.gitprompt

if [ -f ~/.profile_custom ]; then
  source ~/.profile_custom
fi
