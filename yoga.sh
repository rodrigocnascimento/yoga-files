#!/bin/zsh

set -e

YOGA_HOME=~/.yoga

export YOGA_HOME

source lib/*

function yoga_install() {
  # yoga_updater &&
    install_scripts &&
    yoga_success "ROUND 2 ... FIGHT!"

  return 0
}

function yoga() {
  (
    yoga_install
  ) || (
    yoga_success "yoga was installed"
  )
}

yoga
