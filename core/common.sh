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

function copy_dot_files {
   yoga_action "copying files to" $HOME

   cp core/git/.gitconfig ~

   cp core/git/.gitignore_global ~
}

function update_yoga {
   local UPSTREAM=${1:-'@{u}'}
   local LOCAL=$(git -C $YOGA_HOME rev-parse @)
   local REMOTE=$(git -C $YOGA_HOME rev-parse "$UPSTREAM")
   local BASE=$(git -C $YOGA_HOME merge-base @ "$UPSTREAM")

   if [ $LOCAL = $REMOTE ]; then
      yoga_action "update_yoga" "Up-to-date"
   elif [ $LOCAL = $BASE ]; then
      yoga_action "updating_yoga" "Need to pull"
      yoga_warn "ROUND 2 ... UPDATING!"
      git pull --rebase
   elif [ $REMOTE = $BASE ]; then
      yoga_action "update_yoga" "Need to push"
   else
      yoga_fail "Repository diverged!"
   fi
}

function install_yoga {
   git clone git@github.com:rodrigocnascimento/yoga-files.git $YOGA_HOME
}

function set_init_on_shell {
   if [ -z "$(grep -rw "source $YOGA_HOME/init.sh" ~/.zshrc)" ]
      then
      yoga_warn "set initial bootstrap on ~/.zshrc"
      echo "\nsource $YOGA_HOME/init.sh" >> ~/.zshrc
   fi

   source ~/.zshrc
}

export update_yoga
export install_yoga
export copy_dot_files
export workspace_install
