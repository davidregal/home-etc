# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Debug
echo "Entering .bashrc"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

########################### Color and Prompt ###################################

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    # OSX Mountain Lion and up changed the Terminal type from xterm-color to xterm-256color
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # The method I use is to generate a color for the hostname from the hostname. There are not many colors to choose from so it will easily generate clashes, but it's useful for the small amount of machines that I manage.
   # The first line generates a number between 30 (inc) and 36 (exc) from the hostname of the machine. The second line applies it to the prompt with username and path in green (32) and the host name in the generated color.
    # No background colors are set, and I exclude cyan (36) and white (37) from the foreground to avoid clashes with the backgrounds of terminals that I use. Credit: http://serverfault.com/questions/221108/different-color-prompts-for-different-machines-when-using-terminal-ssh/425657#425657.
    hostnamecolor=$(hostname | od | tr ' ' '\n' | awk '{total = total + $1}END{print 30 + (total % 6)}')
    #Original from SO: 
    #PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\[\e[${hostnamecolor}m\]\]\h \[\e[32m\]\w\[\e[0m\]\n$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\e[${hostnamecolor}m\]\]\h:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

########################### Completion #########################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

############################### Aliases ########################################
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

############################### History ########################################

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=100000          # big big history
shopt -s histverify # edit a recalled history line before executing

################### Allow history accross all Term windows #####################
# Credit: http://stackoverflow.com/questions/103944/real-time-history-export-amongst-bash-terminal-windows/3055135#3055135

# Here is my [lesmana] attempt at Bash session history sharing. This will enable history sharing in a way that the history counter does not get mixed up and history expansion like !number will work with some constraints.

# The function history() overrides the builtin history to make sure that the history is synchronised before it is displayed. This is necessary for the history expansion by number (more about this later).
history() {
_bash_history_sync
	builtin history "$@"
}

# Save and reload the history after each command finishes
_bash_history_sync() {
  builtin history -a         #[1]
  HISTFILESIZE=$HISTFILESIZE #[2]
  builtin history -c         #[3]
  builtin history -r         #[4]
}

#[1] Append the just entered line to the $HISTFILE (default is .bash_history). This will cause $HISTFILE to grow by one line.

#[2] Setting the special variable $HISTFILESIZE to some value will cause Bash to truncate $HISTFILE to be no longer than $HISTFILESIZE by removing the oldest entries.

#[3] Clear the history of the running session. This will reduce the history counter by the amount of $HISTSIZE.

#[4] Read the contents of $HISTFILE and insert them in to the current running session history. this will raise the history counter by the amount of lines in $HISTFILE.

#More explanation:
#
# Step [1] ensures that the command from the current running session gets written to the global history file.
#
# Step [4] ensures that the commands from the other sessions gets read in to the current session history.
#
# Because step [4] will raise the history counter, we need to reduce the counter in some way. This is done in step [3].
#
# In step [3] the history counter is reduced by $HISTSIZE. In step [4] the history counter is raised by the number of lines in $HISTFILE. In step [2] we make sure that the line count of $HISTFILE is exactly $HISTSIZE (this means that $HISTFILESIZE must be the same as $HISTSIZE).

# Strange bugs:

# Running the history command piped to anything will result that command to be listed in the history twice. For example:
#
#$ history | head
#$ history | tail
#$ history | grep foo
#$ history | true
#$ history | false
# All will be listed in the history twice. I have no idea why.

# Ideas for improvements:

# Modify the function _bash_history_sync() so it does not execute every time. For example it should not execute after a CTRL+C on the prompt. I often use CTRL+C to discard a long command line when I decide that I do not want to execute that line. Sometimes I have to use CTRL+C to stop a Bash completion script.

# Commands from the current session should always be the most recent in the history of the current session. This will also have the side effect that a given history number keeps its value for history entries from this session.

export PROMPT_COMMAND=_bash_history_sync

############################# Editors ##########################################
# Command Line Editor
set -o vi
# Editor for SVN
export SVN_EDITOR=vi


############################# SSH ##########################################
# Start the complementary tool to remember passwords 

platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
	platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='osx'
fi

if [[ $platform == 'linux' ]]; then
	echo "Setting up SSH Agent"
	# If no SSH agent is already running, start one now. Re-use sockets so we never
	# have to start more than one session.
	# What the block below does is, it sets the socket filename manually to /home/yourusername/.ssh-socket. It then runs ssh-add, which will attempt to connect to the ssh-agent through the socket. If it fails, it means no ssh-agent is running, so we do some cleanup and start one.
	# Credit: http://www.electricmonk.nl/log/2012/04/24/re-use-existing-ssh-agent-cygwin-et-al/
	export SSH_AUTH_SOCK=~/.ssh/ssh-socket

	ssh-add -l >/dev/null 2>&1
	if [ $? = 2 ]; then
		# No ssh-agent running
		rm -rf $SSH_AUTH_SOCK
		# >| allows output redirection to over-write files if no clobber is set
		ssh-agent -a $SSH_AUTH_SOCK >| /tmp/.ssh-script
		source /tmp/.ssh-script
		echo $SSH_AGENT_PID >| ~/.ssh/ssh-agent-pid
		rm /tmp/.ssh-script
		ssh-add ~/.ssh/id_rsa
	fi
fi

# Debug
echo "Leaving .bashrc"
