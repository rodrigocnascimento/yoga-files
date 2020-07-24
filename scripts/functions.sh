# look for the id based on a port
function pid_port {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

# kill a process based on a port
function kill_port {
  if [[ $(pid_port :$1) -ne "" ]]; then
    kill -9 $(pid_port ":$1")
  fi
}

# create a directory and enter it
function take {
  mkdir -p $@ && cd ${@:$#}
}

# running ssh agent
function ssh_agent_run {
  eval `ssh-agent -s`; ssh-add; ssh-add -k ~/.ssh/$@
}

# rerun the last command but with sudo
function please {
  sudo $(fc -ln -1)
}

# show user ip
function echo_ip {
  print_f("%s", curl http://ipecho.net/plain)
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