#!/bin/bash
PROMPT_COMMAND=prompt

 # Carrega os arquivos de ambiente
source ~/.yoga/.aliases
source ~/.yoga/.functions
source ~/.yoga/.envvars
source ~/.yoga/.bash_poweline

if [ -f ~/.profile_custom ]; then
    source ~/.profile_custom
fi
