##################
# Code # Colors  #
##################
#  00  # Off     #
#  30  # Black   #
#  31  # Red     #
#  32  # Green   #
#  33  # Yellow  #
#  34  # Blue    #
#  35  # Magenta #
#  36  # Cyan    #
#  37  # White   #
##################

function yoga_fail {
   echo "\033[1;31m✖ $1 ✖\033[0m"
}

function yoga_success {
   echo "\033[1;32m✔ $1 ✔\033[0m"
}

function yoga_message {
   echo "\033[1;34m $1 \033[0m"
}


function yoga_warn {
   echo "\033[1;33m⚠ $1 ⚠\033[0m"
}

function yoga_action {
   echo  "\033[1;33m==> [$1] $2 ✔\033[0m"
}

function yoga_readln {
   echo -n $1
   read answer
}

export yoga_success
export yoga_action
export yoga_warn
export yoga_fail
export yoga_message
export yoga_readln