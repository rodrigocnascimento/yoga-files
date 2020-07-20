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

function does_yoga_need_update? {
  if ! git diff --quiet remotes/origin/HEAD; then
    return 0
  else 
    yoga_success "yoga does not need updates"
  fi
}

function source_scripts {
  for script in $YOGA_HOME/scripts/*.sh; do
    echo $script
  done
}

export source_scripts
export does_yoga_need_update?
export yoga_success
export yoga_fail
export yoga_readln
