alias cd='pushd'
alias ..='cd ..'
alias ~='cd ~'
alias lsd='ls -lahF'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Docker aliases

# To clear containers:
alias dkcls='docker rm -f $(docker ps -a -q)'

# To clear images:
alias dkrmi='docker rmi -f $(docker images -a -q)'

# To clear volumes:
alias dkrmvl='docker volume rm $(docker volume ls -q)'

# To clear networks:
alias dkrmnet="docker network rm $(docker network ls | tail -n+2 | awk '{if($2 !~ /bridge|none|host/){ print $1 }}')"