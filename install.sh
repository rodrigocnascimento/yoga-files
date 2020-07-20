#!/bin/zsh

set -e 

YOGA_HOME=~/.yoga

export YOGA_HOME

source lib/*

function yoga_install {
  if does_yoga_need_update?; then
    echo "Rebasing REPO git pull --rebase" && yoga_success "ROUND 2 ... FIGHT!"
  fi

  (
    source_scripts &&

    yoga_success "yoga installed"
  ) || (
    yoga_fail "yoga installation failed"
  )
}

function yoga {
  (
    yoga_install
  ) || (
    yoga_success "yoga was installed"
  )
}

yoga
