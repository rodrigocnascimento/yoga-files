#!/bin/zsh

source core/common.sh

function yoga {
  yoga_warn "ROUND 1 ... FIGHT!" && install_yoga

  copy_dot_files &&

  workspace_install &&
  
  set_init_on_shell &&
  
  yoga_success "⭐⭐⭐YOU WIN!⭐⭐⭐" 
}

yoga
