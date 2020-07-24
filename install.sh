#!/bin/zsh

set -e 

YOGA_HOME=~/.yoga

export YOGA_HOME

source lib/*

function yoga_install {
  echo "Updating Yoga\n"

  update_yoga && 

  source_scripts &&
  
  cp scripts/.gitconfig ~ &&
  
  cp scripts/.gitignore_global ~

  yoga_success "ROUND 2 ... FIGHT!" 

  return 1
}

function yoga {
  (
    yoga_install
  ) || (
    yoga_success "yoga was installed"
  )
}

yoga
