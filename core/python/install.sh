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

# pip3 
if which pip3 &> /dev/null; then
    yoga_success "pip3 already installed"
else
    yoga_warn "NEED TO INSTALL pip3"
    exit 1
fi

# yamllint 
if which yamllint &> /dev/null; then
    yoga_success "yamllint already installed"
else
    yoga_action "install" "yamllint"
    pip3 install --user yamllint
    mkdir -p $HOME/.config/yamllint

    yoga_action "config" "yamllint"
    cp config ~/.config/yamllint/config

    yoga_success "instaled yamllint"
fi
