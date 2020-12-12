#!/bin/zsh
DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/../utils.sh"

# fzf
if which fzf &> /dev/null; then
    yoga_success "fzf already installed"
else
    yoga_action "installing" "fzf ➜ https://github.com/junegunn/fzf"
    
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

    ~/.fzf/install
    
    yoga_success "fzf installed"
fi

# rofi
if which rofi &> /dev/null; then
    yoga_success "rofi already installed"
else
    yoga_action "installing" "rofi ➜ https://github.com/davatorium/rofi"
    
    sudo apt install rofi -y
    
    yoga_success "rofi installed"
fi

# glances
if which htop &> /dev/null; then
    yoga_success "htop already installed"
else
    yoga_action "installing" "htop"
    
    sudo apt install htop -y
    
    yoga_success "htop installed"
fi

# curl
if which curl &> /dev/null; then
    yoga_success "curl already installed"
else
    yoga_action "installing" "curl ➜ https://curl.se/"
    
    sudo apt install curl
    
    yoga_success "curl installed"
fi





