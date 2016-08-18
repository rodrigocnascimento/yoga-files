#!/bin/bash
YOGA_HOME=~/.yoga-files

export YOGA_HOME

# MAMP
export MAMP_PHP=/Applications/MAMP/bin/php/php5.6.10/bin
export PATH="$MAMP_PHP:$PATH"

# LOAD NVM
export NVM_DIR="/Users/darth-tyranus/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  

# BIN PATH
export PATH="/usr/local/sbin:$PATH"
