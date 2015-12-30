#!/bin/bash

if ! [ -x "$(command -v git)" ];
    then
        echo 'git is not installed'
else
    `git --version`
fi

#export IS_GIT_AVAILABLE
# sub_yoga_install_git(){
#     printf "Installando git... \n"
#     sudo apt-get install git
# }
#
# if [[ "$IS_GIT_AVAILABLE" -eq 0 ]]; then
#     echo "TRUEsss"
# else
#     printf "Você precisa instalar o git antes. Devo tentar instalar? [S/N] "
#     read _ANSWER
#     if [[ "$_ANSWER" =~ [Ss]  ]]; then
#         sub_yoga_install_git
#     elif [[ "$_ANSWER" =~ [Nn]  ]]; then
#         printf "Para baixar, preciso do git. Caso não queira usar, baixe o .yoga_files e instale manualmente ;) \n"
#     else
#         printf "Dê uma resposta válida"
#     fi
# fi
