#!/bin/bash
source envvars.sh
git --version > /dev/null

GIT_IS_AVAILABLE=$?

sub_yoga_install_git(){
    printf "Installando git... \n"
    sudo apt-get install git
}

sub_yoga_clone(){
    printf "mkdir ~/.yoga-files \n"
        sudo mkdir "$YOGA_HOME" 
    printf "git clone ~/.yoga-files \n"
        #git clone git@github.com:rodreego/yoga-files.git "$YOGA_HOME"
}

if [[ "$GIT_IS_AVAILABLE" -eq 0 ]]; then
echo TRUE    
#sub_yoga_clone
    #if [ -d $YOGA_HOME || -f $YOGA_HOME/install.sh  ]; then
     #   printf "Instalado com sucesso"
    #fi
else
    printf "Você precisa instalar o git antes. Devo tentar instalar? [S/N] "
    read _ANSWER
    if [[ "$_ANSWER" =~ [Ss]  ]]; then
        sub_yoga_install_git
    elif [[ "$_ANSWER" =~ [Nn]  ]]; then
        printf "Para baixar, preciso do git. Caso não queira usar, baixe o .yoga_files e instale manualmente :) \n" 
    else
        printf "Dê uma resposta válida"
    fi
fi
