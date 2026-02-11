#!/bin/zsh
DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/../utils.sh"

# qterminal
if which qterminal &>/dev/null; then
    yoga_success "qterminal already installed"
else
    yoga_action "installing" "qterminal ➜ https://github.com/lxqt/qterminal"

    sudo apt install qterminal

    yoga_success "qterminal installed"

    # regolith config to change the terminal emulator
    sudo update-alternatives --config x-terminal-emulator
fi

# fzf
if which fzf &>/dev/null; then
    yoga_success "fzf already installed"
else
    yoga_action "installing" "fzf ➜ https://github.com/junegunn/fzf"

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

    ~/.fzf/install

    yoga_success "fzf installed"
fi

# htop
if which htop &>/dev/null; then
    yoga_success "htop already installed"
else
    yoga_action "installing" "htop"

    sudo apt install htop -y

    yoga_success "htop installed"
fi

# xclip
if which xclip &>/dev/null; then
    yoga_success "xclip already installed"
else
    yoga_action "installing" "xclip"

    sudo apt install xclip

    yoga_success "xclip installed"
fi

# curl
if which curl &>/dev/null; then
    yoga_success "curl already installed"
else
    yoga_action "installing" "curl ➜ https://curl.se/"

    sudo apt install curl

    yoga_success "curl installed"
fi

# vim
yoga_action "installing" "vim ➜ https://github.com/vim/vim"
if which nvim &>/dev/null; then
    yoga_success "nvim already installed"
else
    sudo apt install nvim
    yoga_success "nvim installed"
fi
# vim plugin install
yoga_action "copying" "vim configs to ~"
if [ ! -d "$HOME/.vim" ]; then
    mkdir ~/.vim
fi

if [ ! -d "$HOME/.config/nvim" ]; then
    mkdir -p ~/.config/nvim
fi

cp core/terminal/vimrc ~/.config/nvim/init.vim

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    yoga_action "installing" "vim-plug ➜ https://github.com/junegunn/vim-plug"
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    yoga_action "installing plugins to vim" "vim +PlugInstall"
    vim --headless +PlugInstall +qall
    yoga_success "nvim configured"
else
    yoga_action "silently installing plugins to vim" "vim +PlugInstall"
    vim --headless +PlugUpdate +qall >/dev/null 2>&1
    yoga_success "nvim configured"
fi

if [ ! -d "$ZSH" ]; then
    yoga_action "installing" "oh-my-zsh ➜ https://github.com/ohmyzsh/ohmyzsh/"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    yoga_success "oh-my-zsh already installed"
fi

# if [ -d "$ZSH" ]; then
if which zsh &>/dev/null; then
    if [ ! -d "$HOME/.fonts" ]; then
        yoga_action "installing Fonts" "creating fonts dir"
        mkdir -p ~/.fonts
        yoga_action "installing Fonts" "nerdfonts MesloLGS NF Regular ➜ https://github.com/romkatv/powerlevel10k"
    fi

    if [ ! -f "$HOME/.fonts/MesloGS NF Regular.ttf" ]; then
        curl -LIo $HOME/.fonts/MesloGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        file $HOME/.fonts/MesloGS\ NF\ Regular.ttf
    fi

    if [ ! -f "$HOME/.fonts/MesloGS NF Bold.ttf" ]; then
        curl -LIo $HOME/.fonts/MesloGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        file $HOME/.fonts/MesloGS\ NF\ Bold.ttf
    fi

    if [ ! -f "$HOME/.fonts/MesloGS NF Italic.ttf" ]; then
        curl -LIo $HOME/.fonts/MesloGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        file $HOME/.fonts/MesloGS\ NF\ Italic.ttf
    fi

    if [ ! -f "$HOME/.fonts/MesloGS NF Bold Italic.ttf" ]; then
        curl -LIo $HOME/.fonts/MesloGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
        file $HOME/.fonts/MesloGS\ NF\ Bold\ Italic.ttf
    fi

    yoga_action "updating Fonts cache" "fc-cache"
    sudo fc-cache -fv >>/dev/null

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        yoga_action "installing" "powerlevel10k ➜ https://github.com/romkatv/powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >>~/.zshrc
    else
        yoga_success "powerlevel10k is alreay installed, please consider update: https://github.com/romkatv/powerlevel10k/releases"
    fi
fi
