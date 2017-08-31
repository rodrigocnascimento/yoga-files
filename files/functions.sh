function canary_debugger() {
  canary --remote-debugging-port=$1 http://localhost:$1
}

function pid_port() {
  echo $(lsof -n -i :$1 | grep LISTEN | awk '{print $2}')
}

function kill_port() {
  echo kill -9 $(pid_port)
}

