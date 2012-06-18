[ -n "$PS1" ] && source ~/.bash_profile

test=`/bin/ps -ef | /usr/bin/grep ssh-agent | /usr/bin/grep -v grep  | /usr/bin/awk '{print $2}' | xargs`

if [ "$test" = "" ]; then
   # there is no agent running
   if [ -e "$HOME/agent.sh" ]; then
      # remove the old file
      /bin/rm -f $HOME/agent.sh
   fi;
   # start a new agent
   /usr/bin/ssh-agent | /usr/bin/grep -v echo >&$HOME/agent.sh 
fi;

export PATH=/usr/local/bin:$PATH:/usr/local/gsutil

test -e $HOME/agent.sh && source $HOME/agent.sh

alias kagent="kill -9 $SSH_AGENT_PID"
