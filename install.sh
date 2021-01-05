#!/bin/zsh

source core/common.sh

function yoga {
  yoga_warn "ROUND 1 ... FIGHT!" && install_yoga

  workspace_install &&
  
  copy_dot_files &&

  set_init_on_shell &&
  
  yoga_success "⭐⭐⭐YOU WIN!⭐⭐⭐" 
}

yoga
