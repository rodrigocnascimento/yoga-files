#!/bin/zsh

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/../utils.sh"

yoga_action "copying default .gitconfig" "core/git/.gitconfig to ~"
cp core/git/.gitconfig ~

yoga_action "copying .gitconfig_basic" "core/git/.gitconfig_basic to ~"
cp core/git/.gitconfig_basic ~/code/.gitconfig

yoga_action "copying" "core/git/.gitignore_global to ~"
cp core/git/.gitignore_global ~

yoga_action "core.excludefile param" "git config --global core.excludesfile ~/.gitignore_global"
git config --global core.excludesfile ~/.gitignore_global

yoga_success "git configured successfuly"
