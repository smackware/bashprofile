# This is derived from https://gist.github.com/specious/8244801
# Modified by Smackware for extra flexibility
#
# Fancy two-line prompt with git integration
#
# ┌───=[hh:mm:ss]=[user@host] -( jobs )-[ ~ ]-( master )
# └──(
#
MC=34
UC=33
RC=31
HC=39
GC=32 # Git clean
GD=31 # Git dirty
TC=32

LONG_PROMPT_MIN_COLUMNS=120
MAX_DIR_LENGTH_LONG=40
MAX_DIR_LENGTH_SHORT=40

parse_git_branch_color () {
  if [[ $(git status 2> /dev/null | tail -1) != "nothing to commit, working tree clean" ]]; then
	  echo $GD
  else
	  echo $GC
  fi
}

parse_git_branch_clean () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/^* //g'
}

parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

show_git_prompt () {
  git branch 2>/dev/null 1>&2 && echo -e "-( \e[$(parse_git_branch_color);1m${GB}\e[$MC;1m )"
}

[ "$EUID" -eq 0 ] && MC=$RC

GIT_STAT=""
PS1_LONG="
\[\e[$MC;1m\]┌─=[\[\e[$TC;1m\]\t\[\e[$MC;1m\]]=[ \[\e[$UC;1m\]\u\[\e[$MC;1m\]@\[\e[$HC;1m\]\h\[\e[$MC;1m\] ]-( \[\e[39;1m\]\j\[\e[$MC;1m\] )-[ \[\e[39;1m\]\$SHORT_DIR\[\e[$MC;1m\] ]\$GIT_STAT
\[\e[$MC;1m\]└\\$ \[\e[0m\]"

PS1_SHORT="\[\e[$MC;1m\][\[\e[$UC;1m\]\u\[\e[$MC;1m\]@\[\e[$HC;1m\]\h\[\e[$MC;1m\]:\$SHORT_DIR] \\$ \[\e[0m\]"

prompt_cmd()
{
  SHORT_DIR=${PWD/$HOME/\~}
  DIR_LENGTH=$MAX_DIR_LENGTH_LONG
  if [ "$COLUMNS" -lt $LONG_PROMPT_MIN_COLUMNS ]; then
     DIR_LENGTH=$MAX_DIR_LENGTH_SHORT
  fi
  if [ "${#SHORT_DIR}" -gt "$DIR_LENGTH" ]; then
    let SHORT_DIR_LEN=$DIR_LENGTH-3
    SHORT_DIR="...${SHORT_DIR: -$SHORT_DIR_LEN}"
  fi
  GB=$(parse_git_branch_clean)
  if [[ -n $(type -t git) ]] ; then
    GIT_STAT="$(show_git_prompt)"
  else
    GIT_STAT=""
  fi
  if [ "$COLUMNS" -lt $LONG_PROMPT_MIN_COLUMNS ]; then
    PS1="$PS1_SHORT"
  else
    PS1="$PS1_LONG"
  fi
}

# Display running command in GNU Screen window status
#
# In .screenrc, set: shelltitle "( |~"
#
# See: http://aperiodic.net/screen/title_examples#setting_the_title_to_the_name_of_the_running_program
case $TERM in screen*)
  PS1=${PS1}'\[\033k\033\\\]'
esac

PROMPT_COMMAND=prompt_cmd
