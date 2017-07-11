# Homebrew PHP CLI
export PATH="$(brew --prefix homebrew/php/php71)/bin:$PATH"

# LOAD NVM
export NVM_DIR="/Users/darth-tyranus/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# BIN PATH
export PATH="/usr/local/sbin:$PATH"

# laravel composer
export PATH="$PATH:$HOME/.composer/vendor/bin"

# python wrapper env
export VIRTUALENVWRAPPER_PYTHON=/usr/local/Cellar/python3/3.6.0_1/bin/python3

# Locale Settings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

