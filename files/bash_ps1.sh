COLGRAY="\[\033[90m\]"
COLYELLOW="\[\033[33m\]"
COLCYAN="\[\033[96m\]"
COLGREEN="\[\033[92m\]"
COLBLUE="\[\033[94m\]"
BACKBLUE="\[\033[104m\]"
COLRED="\[\033[31m\]"
COLCLEAR="\[\033[0m\]"

function we_are_in_git_work_tree {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function parse_git_branch {
  if we_are_in_git_work_tree
  then
    local BR=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)
    local COUNT_MODIFIED=$(git status -s | wc -l | sed 's/ //g')
    local COUNT_AHEAD=0
    let ORIGIN_EXIST=$(git branch -a | ack remotes/origin/$BR | wc -l | sed 's/ //g')

    if [ $ORIGIN_EXIST -ge "1" ]
    then
      COUNT_AHEAD=$(git log origin/$BR..$BR --oneline | wc -l | sed 's/ //g')
    else
      COUNT_AHEAD=$(git log --branches --not --remotes --oneline | wc -l | sed 's/ //g')
    fi

    if [ "$BR" == HEAD ]
    then
      local NM=$(git name-rev --name-only HEAD 2> /dev/null)
      if [ "$NM" != undefined ]
      then echo -n "@$NM"
      else git rev-parse --short HEAD 2> /dev/null
      fi
    else
      echo -n "$BR ≠ $COUNT_MODIFIED ⇡ $COUNT_AHEAD"
    fi
  fi
}

function parse_git_status {
  if we_are_in_git_work_tree
  then
    local ST=$(git status --short 2> /dev/null)
    if [ -n "$ST" ]
    then echo -n " ? "
    else echo -n " o "
    fi
  fi
}

function pwd_depth_limit_2 {
  if [ "$PWD" = "$HOME" ]
  then echo -n "~"
  else pwd | sed -e "s|.*/\(.*/.*\)|\1|"
  fi
}


# export all these for subshells
export -f parse_git_branch parse_git_status we_are_in_git_work_tree pwd_depth_limit_2
export PS1="$COLBLUE\$(pwd_depth_limit_2)\$(parse_git_status)$COLGRAY\$(parse_git_branch)\n$BACKBLUE$COLYELLOW λ $COLCLEAR "
export TERM="xterm-color"
