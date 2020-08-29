#!/bin/zsh
setopt globdots

function yoga_fail() {
   echo $1
   return 1
}

function yoga_success() {
   echo $1
   return 0
}

function yoga_readln() {
   echo -n $1
   read answer
   return 0
}

function yoga_updater() {
   # kindly copied from
   # https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/upgrade.sh
   # Set git-config values known to fix git errors
   # Line endings (#4069)
   git config core.eol lf
   git config core.autocrlf false
   # zeroPaddedFilemode fsck errors (#4963)
   git config fsck.zeroPaddedFilemode ignore
   git config fetch.fsck.zeroPaddedFilemode ignore
   git config receive.fsck.zeroPaddedFilemode ignore
   # autostash on rebase (#7172)
   resetAutoStash=$(git config --bool rebase.autoStash 2>&1)
   git config rebase.autoStash true

   echo "Rebasing REPO git pull --rebase"
   if git pull --rebase --stat origin master; then
      yoga_success "Yoga Files atualizado com sucesso"
   else
      yoga_fail "Yoga Files não foi atualizado"
   fi

   # Unset git-config values set just for the upgrade
   case "$resetAutoStash" in
   "") git config --unset rebase.autoStash ;;
   *) git config rebase.autoStash "$resetAutoStash" ;;
   esac
}

function install_system_scripts() {
   for script in $YOGA_HOME/scripts/system/*; do
      echo $script
      source $script
   done
}

function install_git_scripts() {
   for script in $YOGA_HOME/scripts/git/*; do
      echo $script
      cp $script $HOME
   done
}

export install_system_scripts
export install_git_scripts
export yoga_updater
export yoga_success
export yoga_fail
export yoga_readln
