#!/bin/bash
# YOGA FILES INSTAL

# first we need to check if the directory exists
source envvars.sh
source ./subroutines/messages.sh

yoga_install(){
    printf "installing yoga-files \n"
    source ./subroutines/is_git_installed.#!/bin/sh

    # creating .yoga-files dir
    mkdir -p ${YOGA_HOME}

    # creating dir to backup old files
    mkdir -p ${YOGA_HOME}/old_files

    # backing up old files
    mv ~/.bashrc ${YOGA_HOME}/old_files

    #if [ $_IS_GIT_INSTALLED -eq 0 ]; then
    #    printf "cloning yoga-files \n"
    #    git clone https://github.com/rodreego/yoga-files.git ${YOGA_HOME}
    #fi
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
    fi
}

# Function that verifies if yoga-files is installed
is_yoga_installed?
