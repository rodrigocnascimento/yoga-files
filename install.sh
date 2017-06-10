#!/bin/bash

source envvars.sh
source messages.sh

yoga_install(){
    if [[ "$OSTYPE" == "darwin"* ]]; then
        cp workspace.sh $YOGA_HOME/.workspace
        cp files/home_aliases $YOGA_HOME/.aliases
        cp files/bash_powerline.sh $YOGA_HOME/.bash_powerline.sh
        cp files/home_functions $YOGA_HOME/.functions
        cp files/home_envvars $YOGA_HOME/.envvars
        cp files/.gitconfig ~/.gitconfig

        echo -e "\n source " $YOGA_HOME/.workspace "\n" >> ~/.profile
        source ~/.profile

        yoga_ok
    fi
}

yoga_update(){
	echo "ROUND 2 ... FIGHT! Rebasing REPO"
	git pull --rebase

    echo "Reinstalling"
    yoga_install

    echo "I think we're done"
}

yoga_quit(){
    yoga_fail
}

is_yoga_installed?(){
    if [ ! -d $YOGA_HOME ]; then
        echo -n ".yoga não está instalado ~> INSTALL [Y/N] "
        read  _ANSWER

        if [[ "$_ANSWER" =~ [Yy] ]]
         then
            printf "Installing ~/.yoga \n"
            mkdir $YOGA_HOME

            echo "ROUND 1 files!"
            yoga_install
        elif [[ "$_ANSWER" =~ [Nn] ]]
         then
            yoga_quit
        else
            echo "YES (Yy) NO (Nn) pls :)"
            is_yoga_installed?
        fi
    else
        echo ".yoga está instalado ~> UPDATE [Y/N] "
        read  _ANSWER

        if [[ "$_ANSWER" =~ [Yy] ]]
         then
            yoga_update
        fi
    fi
}

# Function that verifies if yoga-files is installed
is_yoga_installed?
