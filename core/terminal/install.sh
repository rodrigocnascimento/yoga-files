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

# htop
if which htop &> /dev/null; then
    yoga_success "htop already installed"
else
    yoga_action "installing" "htop"
    
    sudo apt install htop -y
    
    yoga_success "htop installed"
fi

# xclip 
if which xclip &> /dev/null; then
    yoga_success "xclip already installed"
else
    yoga_action "installing" "xclip"
    
    sudo apt install xclip
    
    yoga_success "xclip installed"
fi

# curl
if which curl &> /dev/null; then
    yoga_success "curl already installed"
else
    yoga_action "installing" "curl ➜ https://curl.se/"
    
    sudo apt install curl
    
    yoga_success "curl installed"
fi

# vim
yoga_action "installing" "vim ➜ https://github.com/vim/vim"
if which vim &> /dev/null; then
    yoga_success "vim already installed"
else
    sudo apt install vim
    yoga_success "vim installed"
fi
# vim plugin install
yoga_action "copying" "vim configs to ~"
if [ ! -d "$HOME/.vim" ]; then
    mkdir ~/.vim
fi
cp core/terminal/vimrc ~/.vimrc

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    yoga_action "installing" "vim-plug ➜ https://github.com/junegunn/vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    
    yoga_action "installing plugins to vim" "vim +PlugInstall"
    vim +PlugInstall +qall >/dev/null 2>&1
    yoga_success "vim configured"
else
    yoga_action "installing plugins to vim" "vim +PlugInstall"
    vim +PlugInstall +qall >/dev/null 2>&1
    yoga_success "vim configured"
fi

if [ ! -d "$ZSH" ]; then
    yoga_warning "changing to zshell" 
    sudo chsh -s /bin/zsh
    
    yoga_action "installing" "oh-my-zsh ➜ https://github.com/ohmyzsh/ohmyzsh/"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    yoga_success "oh-my-zsh already installed"
fi



