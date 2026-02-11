#!/bin/zsh

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/../utils.sh"

# nvm
  yoga_action "installing or updating" "~/.nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

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
