#!/bin/bash
# YOGA FILES INSTAL

# first we need to check if the directory exists
source envvars.sh
source messages.sh

yoga_install(){
    printf "installing yoga-files \n"

    # creating .yoga-files dir and backup oldfiles dir
    if [ ! -d ${YOGA_HOME}/old_files ]; then
        mkdir -p ~/.profile ${YOGA_HOME}/old_files
    fi

    # here we need to check whatever 
    # os is and create the files properly
    # for now only macosx
    if [ ! -e ~/.profile ]; then
        mv ~/.profile ${YOGA_HOME}/old_files
    fi

    # if [ ! -e ~/.bash_* ]; then
    #     mv ~/.bash_* ${YOGA_HOME}/old_files
    # fi

    cp files/bash_aliases ~/.profile_aliases
    cp files/bash_functions ~/.profile_functions
    cp files/envvars ~/.profile_envvars
    cp files/bashrc ~/.profile

    source ~/.profile
    source ~/.profile_aliases
    source ~/.profile_functions
    source ~/.profile_envvars
    
    yoga_ok
}

yoga_quit(){
    yoga_fail
}

is_yoga_installed?(){
    if [ ! -d $YOGA_HOME ]; then
        echo -n "yoga-files isn't installed ~> wish to proceed the installation? [Y/N] "
        read  _ANSWER

        if [[ "$_ANSWER" =~ [Yy] ]]
         then
            yoga_install
        elif [[ "$_ANSWER" =~ [Nn] ]]
         then
            yoga_quit
        else
            echo "answer YES (Yy) or NO (Nn)"
            is_yoga_installed?
        fi
    else
        echo "yoga-files is installed, wish update?"
        read  _ANSWER

        if [[ "$_ANSWER" =~ [Yy] ]]
         then
            yoga_install
        fi
    fi
}

# Function that verifies if yoga-files is installed
is_yoga_installed?
