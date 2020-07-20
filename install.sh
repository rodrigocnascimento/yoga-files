#!/bin/zsh

set -e 

YOGA_HOME=~/.yoga

export YOGA_HOME

source lib/*

function yoga_install {
  echo "Rebasing REPO git pull --rebase"
  
  git pull --rebase &&
  
  source_scripts &&

  yoga_success "ROUND 2 ... FIGHT!" 

  return 0
}

function yoga {
  (
    yoga_install
  ) || (
    yoga_success "yoga was installed"
  )
}

yoga
