grep=`which grep`
# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$($grep "^Host" ~/.ssh/config | $grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Finder Dock Mail Safari iTunes iCal Address\ Book SystemUIServer" killall

# MacPorts Installer addition on 2011-09-29_at_19:55:30: adding an appropriate PATH variable for use with MacPorts.
export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH

# Finished adapting your PATH environment variable for use with MacPorts.
[ -e "$HOME/.rvm/scripts/rvm" ] && source $HOME/.rvm/scripts/rvm

export RUBYOPT=rubygems


###################### setup ssh keygen stuff
test=`/bin/ps -ef | $grep ssh-agent | $grep -v grep  | /usr/bin/awk '{print $2}' | xargs`

if [ "$test" = "" ]; then
   # there is no agent running
   if [ -e "$HOME/.agent.sh" ]; then
      # remove the old file
      /bin/rm -f $HOME/.agent.sh
   fi;
   # start a new agent
   /usr/bin/ssh-agent | $grep -v echo >&$HOME/.agent.sh
fi;

test -e $HOME/.agent.sh && source $HOME/.agent.sh

alias kagent="kill -9 $SSH_AGENT_PID"

if [ -e $HOME/.ssh/rs/id_rsa ]; then
  ssh-add $HOME/.ssh/rs/id_rsa
  export CLOUD_KEY=$HOME/.ssh/rs/id_rsa
fi

[ -e "/usr/java/default" ] && export JAVA_HOME=/usr/java/default
[ -e "/usr/libexec/java_home" ] && export JAVA_HOME="$(/usr/libexec/java_home)"
[ -e "$HOME/.ec2" ] && export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
[ -e "$HOME/.ec2" ] && export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
[ -e "/usr/local/Cellar/ec2-api-tools/1.5.2.5/jars" ] && export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.2.5/jars"
[ -e "/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars" ] && export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"
[ `which fortune 2> /dev/null` ] && fortune
