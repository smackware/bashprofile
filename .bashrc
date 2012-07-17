# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
PPROFILED="$HOME/.profile.d"
if [ -d "$PPROFILED" ] && ls "$PPROFILED"/* > /dev/null 2>&1; then
  for scr in "$PPROFILED"/*.sh; do
    source $scr;
  done
fi

PATH=$HOME/bin:$PATH
export PATH
