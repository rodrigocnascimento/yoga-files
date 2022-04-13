#!/bin/zsh

set -e 

YOGA_HOME=~/.yoga

export YOGA_HOME

DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/utils.sh"

function workspace_install {
   for script in ./core/**/install.sh; do
      yoga_action "installing" $script
      zsh $script
   done
}

function install_yoga {
   git clone https://github.com/rodrigocnascimento/yoga-files.git $YOGA_HOME
}

function set_init_on_shell {
   echo "source $YOGA_HOME/init.sh"
   if [ ! -z "$(grep -rw "source $YOGA_HOME/init.sh" ~/.zshrc)" ]
      then
      yoga_warn "set initial bootstrap on ~/.zshrc"
      echo "\nsource $HOME/init.sh" >> ~/.zshrc
   fi

   source ~/.zshrc
}

export install_yoga
export workspace_install
export set_init_on_shell
