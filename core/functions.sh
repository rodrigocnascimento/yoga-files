DIR="$(dirname "$(readlink -f "$0")")"

source "$DIR/utils.sh"

# look for the id based on a port
function pid_port {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

# kill a process based on a port
function kill_port {
  if [[ $(pid_port $1) -ne "" ]]; then
    kill -9 $(pid_port "$1")
  fi
}

# create a directory and enter it
function take {
  mkdir -p $@ && cd ${@:$#}
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


read -r -p "It's time to kick ass and chew bubble gum. And I'm all out of gum. [Y/n]" response
  response=${response,,}
  if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    docker_nukem 
  fi


# show user ip
function echo_ip {
  print_f("%s", curl http://ipecho.net/plain)
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
  
  MENU=("projects" "gotodir")

  option=$(echo $MENU | tr " " "\n" | fzf_search)
  
  echo -e "\ngoto ➜ $option"

  eval $option
}
