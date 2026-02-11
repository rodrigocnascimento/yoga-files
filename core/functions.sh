#!/bin/zsh

_yoga_functions_path=""
if [ -n "${ZSH_VERSION-}" ]; then
  _yoga_functions_path="${(%):-%N}"
elif [ -n "${BASH_VERSION-}" ]; then
  _yoga_functions_path="${BASH_SOURCE[0]}"
else
  _yoga_functions_path="$0"
fi

DIR="$(cd "$(dirname "$_yoga_functions_path")" && pwd)"

source "$DIR/utils.sh"

# look for the id based on a port
function pid_port {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

# kill a process based on a port
function kill_port {
  local pid
  pid="$(pid_port "$1")"
  [ -n "$pid" ] && kill -9 "$pid"
}

# create a directory and enter it
function take {
  local last
  last="${@: -1}"
  mkdir -p "$@" && cd "$last"
}

# running ssh agent
function ssh_agent_run {
  ps -eaf $SSH_AGENT_PID > /dev/null || eval `ssh-agent -s`; ssh-add; ssh-add -k ~/.ssh/$@ 2> /dev/null
}

# sudo, but politely
function please {
  sudo $(fc -ln -1)
}

# command to eliminate all docker content EVERYTHING
function docker_nukem {
  # Stop all containers
  docker stop `docker ps -qa`

  # Remove all containers
  docker rm `docker ps -qa`

  # Remove all images
  docker rmi -f `docker images -qa `

  # Remove all volumes
  docker volume rm $(docker volume ls -q)

  # Remove all networks
  docker network rm `docker network ls -q`
}

# Destructive helper with explicit confirmation.
function docker_nukem_confirm {
  echo "This will stop/remove ALL docker containers/images/volumes/networks."
  local response=""
  if [ -n "${ZSH_VERSION-}" ]; then
    read -r "response?Type 'NUKE' to proceed: "
  else
    printf "%s" "Type 'NUKE' to proceed: "
    read -r response
  fi
  if [ "$response" = "NUKE" ]; then
    docker_nukem
  else
    yoga_warn "Cancelled"
  fi
}


# show user ip
function echo_ip {
  curl -fsSL "https://ipecho.net/plain"
}

# dim the monitor brightness
function dim_monitor_light {
  local monitor=$1
  if test -z "$monitor" 
    then 
    monitor=HDMI-1-1
  fi

  xrandr --output $monitor --brightness $1
}

# list process handled by a user or a process_name if none was informed will look for users process
function ls_process_by {
  local process_name=$1
    if test -z "$process_name" 
      then 
      process_name=$USER
    fi

    ps -eHwwo "pid,user,start,size,pcpu,args" \
    | grep $process_name \
    | awk '{print "\n","time "$3,"pid "$1,"user "$2,"mem "$4/1024,"cpu "$5;for(i=1;i<=split(substr($0, index($0, $6)), arg, " ");i++)print "\t",arg[i]}'
}

function fzf_search {
  fzf --query="$@" --height=50% --ansi --tac --color=16 --border
}

function projects {
  cd ~/code/$(ls -la ~/code | awk '{print $9}' | fzf_search)
}

function gotodir {
  pushd $(dirs -l | tr " " "\n" | awk '{print $0}' | fzf_search)
}

function goto {
  yoga_warn "Choose an option:"
  
  option=$(printf "%s\n" "projects" "gotodir" | fzf_search)
  
  echo -e "\ngoto ➜ $option"

  eval $option
}
