#!/bin/zsh

source core/common.sh

function yoga {
  if [[ -d "$YOGA_HOME" ]]; then
    yoga_warn "ROUND 2 ... FIGHT!" && update_yoga
  else
    yoga_warn "ROUND 1 ... FIGHT!" && install_yoga
  fi

  copy_dot_files &&

  workspace_install &&
  
  set_init_on_shell
}

yoga
