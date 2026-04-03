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

# look for the id based on a port with input validation
function pid_port {
  # Validate input is a number
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "⚠️ Invalid port number: $1" >&2
    return 1
  fi
  
  # Validate port range
  if [ "$1" -lt 1 ] || [ "$1" -gt 65535 ]; then
    echo "⚠️ Port number out of range (1-65535): $1" >&2
    return 1
  fi
  
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

# kill a process based on a port with input validation
function kill_port {
  # Validate input is a number
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "⚠️ Invalid port number: $1" >&2
    return 1
  fi
  
  # Validate port range
  if [ "$1" -lt 1 ] || [ "$1" -gt 65535 ]; then
    echo "⚠️ Port number out of range (1-65535): $1" >&2
    return 1
  fi
  
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
  ps -eaf $SSH_AGENT_PID > /dev/null || {
    eval "$(ssh-agent -s)"
    ssh-add
    ssh-add -k ~/.ssh/$@ 2> /dev/null
  }
}

# sudo, but politely - safer version
function please {
  local last_cmd
  last_cmd=$(fc -ln -1)
  # Basic safety check - don't allow empty or obviously dangerous commands
  if [[ -z "$last_cmd" || "$last_cmd" =~ ^(rm|dd|mkfs|>:) ]]; then
    echo "⚠️ Refusing to run potentially dangerous command with sudo: $last_cmd"
    return 1
  fi
  sudo $last_cmd
}

# command to eliminate all docker content EVERYTHING
function docker_nukem {
  # Stop all containers
  docker stop `docker ps -qa` 2>/dev/null || true

  # Remove all containers
  docker rm `docker ps -qa` 2>/dev/null || true

  # Remove all images
  docker rmi -f `docker images -qa ` 2>/dev/null || true

  # Remove all volumes
  docker volume rm $(docker volume ls -q) 2>/dev/null || true

  # Remove all networks
  docker network rm `docker network ls -q` 2>/dev/null || true
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

  # Check if xrandr is available
  if ! command -v xrandr >/dev/null 2>&1; then
    echo "⚠️ xrandr not found. Install xrandr to use this function."
    return 1
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

    # Check if ps is available
    if ! command -v ps >/dev/null 2>&1; then
      echo "⚠️ ps command not found"
      return 1
    fi

    ps -eHwwo "pid,user,start,size,pcpu,args" \
    | grep $process_name \
    | awk '{print "\n","time "$3,"pid "$1,"user "$2,"mem "$4/1024,"cpu "$5;for(i=1;i<=split(substr($0, index($0, $6)), arg, " ");i++)print "\t",arg[i]}'
}

function fzf_search {
  # Check if fzf is available
  if ! command -v fzf >/dev/null 2>&1; then
    echo "⚠️ fzf not found. Install fzf for enhanced search capabilities."
    # Fallback to basic grep
    grep "$@"
    return
  fi
  
  fzf --query="$@" --height=50% --ansi --tac --color=16 --border
}

function projects {
  # Check if ~/code exists
  if [ ! -d "$HOME/code" ]; then
    echo "⚠️ Directory $HOME/code does not exist"
    return 1
  fi
  
  cd ~/code/$(ls -la ~/code | awk '{print $9}' | fzf_search)
}

function gotodir {
  # Check if dirs command is available
  if ! command -v dirs >/dev/null 2>&1; then
    echo "⚠️ dirs command not found"
    return 1
  fi
  
  pushd $(dirs -l | tr " " "\n" | awk '{print $0}' | fzf_search)
}

function goto {
  yoga_warn "Choose an option:"
  
  option=$(printf "%s\n" "projects" "gotodir" | fzf_search)
  
  echo -e "\ngoto ➜ $option"
  
  # Safe execution without eval
  if [[ "$option" == "projects" ]]; then
    projects
  elif [[ "$option" == "gotodir" ]]; then
    gotodir
  else
    echo "❌ Invalid option selected"
  fi
}