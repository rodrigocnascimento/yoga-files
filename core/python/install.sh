#!/bin/zsh

DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/../utils.sh"

# python3 
if which python3 &> /dev/null; then
    yoga_success "python already installed"
else
    yoga_warn "NEED TO INSTALL python3"
    exit 1
fi

# python3 
if which pip3 &> /dev/null; then
    yoga_success "pip3 already installed"

    yoga_action "install" "yamllint"
    pip3 install --user yamllint
    mkdir -p $HOME/.config/yamllint

    yoga_success "instaled yamllint"
else
    yoga_warn "NEED TO INSTALL pip3"
    exit 1
fi

