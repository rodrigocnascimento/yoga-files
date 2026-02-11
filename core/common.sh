#!/bin/zsh

# Common helpers shared by yoga-files scripts.
# Safe to source from other scripts.

export YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

_yoga_common_path=""
if [ -n "${ZSH_VERSION-}" ]; then
  _yoga_common_path="${(%):-%N}"
elif [ -n "${BASH_VERSION-}" ]; then
  _yoga_common_path="${BASH_SOURCE[0]}"
else
  _yoga_common_path="$0"
fi

DIR="$(cd "$(dirname "$_yoga_common_path")" && pwd)"

source "$DIR/utils.sh"

function workspace_install {
   local root="${1:-$YOGA_HOME}"
   local script

   if [ ! -d "$root" ]; then
     yoga_fail "workspace_install: root not found: $root"
     return 1
   fi

   if [ -n "${ZSH_VERSION-}" ]; then
     setopt local_options globstar_short 2>/dev/null || true
     for script in "$root"/core/**/install.sh; do
       [ -f "$script" ] || continue
       yoga_action "installing" "$script"
       zsh "$script"
     done
   else
     yoga_warn "workspace_install: requires zsh globstar"
     return 1
   fi
}

function install_yoga {
   if [ -d "$YOGA_HOME/.git" ]; then
     yoga_action "install_yoga" "Updating existing repo at $YOGA_HOME"
     git -C "$YOGA_HOME" pull --rebase
     return 0
   fi

   git clone https://github.com/rodrigocnascimento/yoga-files.git "$YOGA_HOME"
}

function set_init_on_shell {
   local shell_rc="$HOME/.zshrc"
   [ "${SHELL-}" = "/bin/bash" ] && shell_rc="$HOME/.bashrc"

   [ -f "$shell_rc" ] || touch "$shell_rc"

   if ! grep -q "source \"\$YOGA_HOME/init.sh\"" "$shell_rc" 2>/dev/null \
     && ! grep -q "source $YOGA_HOME/init.sh" "$shell_rc" 2>/dev/null; then
     yoga_warn "Adding yoga bootstrap to $shell_rc"
     cat >> "$shell_rc" << EOF

# Yoga Files Integration
export YOGA_HOME="$YOGA_HOME"
export PATH="\$YOGA_HOME/bin:\$PATH"
source "\$YOGA_HOME/init.sh"
EOF
   else
     yoga_action "bootstrap" "Already configured in $shell_rc"
   fi
}

export install_yoga
export workspace_install
export set_init_on_shell
