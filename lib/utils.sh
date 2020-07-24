#!/bin/zsh

function yoga_fail {
   echo $1
   return 1
}

function yoga_success {
   echo $1
   return 0
}

function yoga_readln {
   echo -n $1
   read answer
   return 0
}

function source_scripts {
  for script in $YOGA_HOME/scripts/*.sh; do
    echo $script
  done
}

function update_yoga {
   local UPSTREAM=${1:-'@{u}'}
   local LOCAL=$(git rev-parse @)
   local REMOTE=$(git rev-parse "$UPSTREAM")
   local BASE=$(git merge-base @ "$UPSTREAM")

   if [ $LOCAL = $REMOTE ]; then
      echo "update_yoga Up-to-date"
   elif [ $LOCAL = $BASE ]; then
      echo "update_yoga Need to pull"
      git pull --rebase
   elif [ $REMOTE = $BASE ]; then
      echo "update_yoga Need to push"
   else
      echo "Diverged"
   fi
}

export update_yoga
export source_scripts
export yoga_success
export yoga_fail
export yoga_readln
