
function pid_port() {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

function kill_port() {
  kill -9 $(pid_port $1)
}

function take() {
  mkdir -p $@ && cd ${@:$#}
}

function ssh_agent_run() {
  eval `ssh-agent -s`; ssh-add; ssh-add -k ~/.ssh/$@
}