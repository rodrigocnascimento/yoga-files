#!/bin/zsh

DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/../utils.sh"

yoga_action "copying" "core/git/.gitconfig to ~"
cp .gitconfig ~

yoga_action "copying" "core/git/.gitignore_global to ~"
cp .gitignore_global ~

yoga_success "git configured successfuly"