#!/bin/zsh

DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/../utils.sh"

# nvm
if [ ! -f "$HOME/.nvm" ]; then
    yoga_action "installing" "~/.nvm"
    export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"
fi

# nodejs
if which node &> /dev/null; then
    yoga_success "node already installed"
else
    yoga_action "installing" "nvm alias default node"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use default
    yoga_success "lts node version installed"
fi

# eslint
if which eslint &> /dev/null; then
    yoga_success "eslint already installed"
else
    yoga_action "install" "npm install -g eslint"
    npm install -g eslint
    yoga_success "eslint installed"
fi


# npkill
if which npkill &> /dev/null; then
    yoga_success "npkill already installed"
else
    yoga_action "install" "npm install -g npkill"
    npm install -g npkill
    yoga_success "npkill installed"
fi

npm -g ls --depth=0
