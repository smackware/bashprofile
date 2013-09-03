export CHEF_SSH_USER='litaln'

chef_environ() {
  export KNIFE_ENVIRONMENT=$1
  echo "Chef-ssh: Switched to $1"
}

knife() {
  CHEF_SSH_KNIFE_CONFIG="$HOME/.chef/knife-$KNIFE_ENVIRONMENT.rb"
  command knife "$@" -c $CHEF_SSH_KNIFE_CONFIG
}

alias ce=chef_environ
