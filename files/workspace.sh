#!/bin/bash

# Carrega os arquivos de ambiente
source ~/.yoga/.aliases
source ~/.yoga/.functions
source ~/.yoga/.envvars
source ~/.yoga/.bash_ps1

if [ -f ~/.profile_custom ]; then
  source ~/.profile_custom
fi
