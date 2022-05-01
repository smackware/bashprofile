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

prompt_cmd()
{
  GB=$(parse_git_branch_clean)
}

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

if [[ -n $(type -t git) ]] ; then
  PS1="\$(show_git_prompt)"
else
  PS1=
fi

[ "$EUID" -eq 0 ] && MC=$RC

PS1="
\[\e[$MC;1m\]┌───=[\[\e[$TC;1m\]\t\[\e[$MC;1m\]]=[ \[\e[$UC;1m\]\u\[\e[$MC;1m\]@\[\e[$HC;1m\]\h\[\e[$MC;1m\] ]-( \[\e[39;1m\]\j\[\e[$MC;1m\] )-[ \[\e[39;1m\]\w\[\e[$MC;1m\] ]$PS1
\[\e[$MC;1m\]└──\\$ \[\e[0m\]"

# Display running command in GNU Screen window status
#
# In .screenrc, set: shelltitle "( |~"
#
# See: http://aperiodic.net/screen/title_examples#setting_the_title_to_the_name_of_the_running_program
case $TERM in screen*)
  PS1=${PS1}'\[\033k\033\\\]'
esac

PROMPT_COMMAND=prompt_cmd
