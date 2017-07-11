#!/bin/bash
YOGA_HOME=~/.yoga

export YOGA_HOME
source messages.sh

yoga_install(){
  if [[ "$OSTYPE" == "darwin"* ]]; then
    cp files/workspace.sh $YOGA_HOME/.workspace
    cp files/aliases.sh $YOGA_HOME/.aliases
    # cp files/ps1.sh $YOGA_HOME/.ps1
    cp files/functions.sh $YOGA_HOME/.functions
    cp files/envvars.sh $YOGA_HOME/.envvars
    cp files/.gitconfig ~/.gitconfig

    echo -e "\n source " $YOGA_HOME/.workspace "\n" >> ~/.profile
    # source_workspace="source $YOGA_HOME/.workspace"
    # sed -e "\|$source_workspace|h; \${x;s|$source_workspace||;{g;t};a\\" -e "$source_workspace" -e "}" ~/.profile
    # grep -q -F $source_workspace ~/.profile || echo $source_workspace >> ~/.profile
    # ack $source_workspace ~/.profile || echo $source_workspace >> ~/.profile

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
