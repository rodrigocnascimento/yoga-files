
function pid_port {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

function kill_port {
  if [[ $(pid_port :$1) -ne "" ]]; then
          kill -9 $(pid_port ":$1")
  fi
}

function take {
  mkdir -p $@ && cd ${@:$#}
}

function ssh_agent_run {
  ps -p $SSH_AGENT_PID > /dev/null || eval `ssh-agent -s`; ssh-add; ssh-add -k ~/.ssh/$@ 2> /dev/null
}

function please {
  sudo $(fc -ln -1)
}

function echo_ip {
  curl 'http://ipecho.net/plain'
}

function dim_monitor_light {
  xrandr --output HDMI-0 --brightness $1
}
