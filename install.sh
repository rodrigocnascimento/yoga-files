#!/bin/bash
# YOGA FILES INSTAL

# first we need to check if the directory exists
#YOGA_HOME=/home/$USER/.yoga-files
source envvars.sh
source subroutines/messages.sh

yoga_install(){
    printf "Instalando YOGA FILES \n"
    source subroutines/git.sh > /dev/null
    _IS_GIT_INSTALLED=$?
    if [ $_IS_GIT_INSTALLED -eq 0 ]; then
        printf "mkdir ${YOGA_HOME} \n"
        mkdir ${YOGA_HOME}        
    fi
}

yoga_quit(){
    echo "Saindo"
}

#if [ "$(id -u)" != "0" ]; then
#   echo "This script must be run as root" 1>&2
#   exit 1
#fi

if [ ! -d $YOGA_HOME ]; then
    echo -n "Yoga Files não está instalado ~> Deseja instalar? [S/N] "
    read  _ANSWER

    if [[ "$_ANSWER" =~ [Ss] ]]
     then
        yoga_install
    elif [[ "$_ANSWER" =~ [Nn] ]]
     then
        yoga_quit
    else
        echo "Responda SIM OU NÃO" 
    fi
fi
