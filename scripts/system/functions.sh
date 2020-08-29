
function pid_port {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

function kill_port {
  if [[ $(pid_port :$1) -ne "" ]]; then
          kill -9 $(get_port ":$1")
  fi
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function ssh_agent_run {
  eval `ssh-agent -s`; ssh-add; ssh-add -k ~/.ssh/$@
}

function please {
  sudo $(fc -ln -1)
}
function echo_ip {
  print_f("%s", curl http://ipecho.net/plain)
}