#!/bin/zsh

alias catapimbas=fuck
alias lsd=ls -la
alias cat=bat
alias vim=nvim
alias code='cd ~/code'
alias pcperf=btm

# RAG
alias rag-status='curl -s http://localhost:8000/info | python -m json.tool'
alias ask="~/rag-server/ask.sh"

#TMUX
alias tmux-list="tmux ls | fzf | cut -d: -f1 | xargs -r tmux attach -t"
alias tmux-kill="tmux ls | fzf | cut -d: -f1 | xargs -r tmux kill-session -t"
alias tmux-kill-pane="tmux list-panes -a -F '#{?pane_active,🔥, } #S:#I.#P #{pane_current_command} #{pane_current_path}' \
| fzf \
| awk '{print $2}' \
| xargs -r tmux kill-pane -t"

alias tmux-kill-pane-local="tmux list-panes -F '#I.#P #{pane_current_command} #{pane_current_path}' \
| fzf \
| awk '{print $1}' \
| xargs -r tmux kill-pane -t"

alias tmux-rename-session="tmux rename-session new_name"
alias tmux-rename-window="tmux rename-window new_name"

# Docker
alias docker-list="docker ps -a | fzf | cut -d' ' -f1 | xargs -r docker attach"
alias docker-rm="docker ps -a | fzf | cut -d' ' -f1 | xargs -r docker rm"
alias docker-rmi="docker images | fzf | cut -d' ' -f1 | xargs -r docker rmi"
alias docker-rm-dangling="docker images -f dangling=true -q | xargs -r docker rmi"
alias docker-rm-all="docker ps -a -q | xargs -r docker rm"
alias docker-rm-stopped="docker ps -a -q | xargs -r docker rm"

# Docker Compose
alias dc-list="docker-compose ps | fzf | cut -d' ' -f1 | xargs -r docker-compose attach"
alias dc-rm="docker-compose ps | fzf | cut -d' ' -f1 | xargs -r docker-compose rm"
alias dc-rmi="docker-compose images | fzf | cut -d' ' -f1 | xargs -r docker-compose rmi"
alias dc-rm-dangling="docker-compose images -f dangling=true -q | xargs -r docker-compose rmi"
alias dc-rm-all="docker-compose ps -a -q | xargs -r docker-compose rm"
alias dc-rm-stopped="docker-compose ps -a -q | xargs -r docker-compose rm"

# Docker Machine
alias dm-list="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine ssh"
alias dm-rm="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine rm"

# Docker Swarm
alias ds-list="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine ssh"
alias ds-rm="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine rm"

# Docker Machine
alias dm-list="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine ssh"
alias dm-rm="docker-machine ls | fzf | cut -d' ' -f1 | xargs -r docker-machine rm"
