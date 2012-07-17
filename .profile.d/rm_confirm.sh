rm() {
  if [[ ${PWD:0:${#HOME}} == $HOME ]]; then
    echo -n "You're in your home directory, are you sure [yes/No]? "
    read answer
    if [[ $answer != "yes" ]] && [[ $answer != "y" ]]; then
      return 1
    fi
    command rm "$@"
    RET=$?
    return $?
  fi
  command rm "$@"
}
