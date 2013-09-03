export CHEF_SSH_USER='litaln'

chef_environ() {
  export KNIFE_ENVIRONMENT=$1
  export KNIFE_CONFIG="$HOME/.chef/knife-$KNIFE_ENVIRONMENT.rb"
  echo "Chef-ssh: Switched to $1"
}

knife() {
  command knife "$@" -c $KNIFE_CONFIG
}

alias ce=chef_environ
