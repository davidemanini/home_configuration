# Bash rc file provided to you by Davide!  Last updated on Jun 25th 2021.
#
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# my programs 
#PATH="~/bin:/usr/sbin:/usr/local/bin:/usr/bin:/usr/games"
PATH="$HOME/bin:/usr/sbin:/sbin:$PATH"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
# Everything must be put after this line.





# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignoredups
HISTFILESIZE=5000
HISTSIZE=5000


# tty defaults
export TERMIOS=`stty -g`

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

 

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

IFS=$'\n'

#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#unalias ls
alias ls='ls -F --color=auto'
alias lsa='ls -a'
alias lst='ls -rt'
alias lsat='ls -art'
alias lsta='ls -art'
alias dir='ls --color=auto --format=vertical'
alias mv="time mv -i"
alias cp="time cp -iRp"
alias scp="time scp -r"
if test -x /usr/bin/trash
then
    alias rm="trash"
else
    alias rm="rm -ir"
fi
alias pst='ps -eH --forest'
alias psu="ps --sort start_time -u $USER"
alias psa='ps --sort start_time -A'
alias psuw='psu w'
alias c='cat'
alias d='ls -lBFh'
alias e='echo'
alias f='file'
alias j='jobs'
alias l='less -ML'
if test -x /usr/bin/gio
then
    alias o='gio open'
else
    alias o='xdg-open'
fi
alias s='screen'
alias sd='screen -D'
alias sr='screen -Dr'
alias v='lesspipe'
alias vl='less -M'
alias cdb='cd $OLDPWD'
alias dt='d -rt'
alias da='d -a'
alias dta='d -art'
alias dat='d -art'
alias ds='d -rS'
#alias ds
alias diff='diff --color=always'
alias meminfo='cat /proc/meminfo'
alias bash='bash -ls'
alias b64='base64'
alias b64d='b64 -d'
alias emacs='emacs -nw'
alias term="$TERMINAL"
alias lynx="lynx -accept_all_cookies -cookie_file=~/.lynx_cookie -cookie_save_file=~/.lynx_cookie "
alias resettty="stty $TERMIOS"
alias edit="$EDITOR"
alias vlc_hdmi="vlc --aout=alsa --alsa-audio-device=plughw:0,3"
alias office2pdf="libreoffice --headless --nologo --convert-to pdf:writer_pdf_Export --print-to-file"
alias untar='tar -zxvf '
alias wget='wget --adjust-extension'
alias python='python3'
#alias beatport2mp3="/shared_data/beatport2mp3/beatport2mp3_1.1/gui4linux.py"

# those have sense on mingw
alias vst_compile="g++ -Wall -Os -s -c -mmmx -fmessage-length=0 -finline-functions -fno-exceptions -fno-rtti -I /e/vstsdk2.4 -I /e/vstsdk2.4/public.sdk/source/vst2.x/"
alias vst_link="g++ -Wall -shared -static /e/vstsdk2.4/public.sdk/source/vst2.x/*.o"

function debchanglog () {
  zless "/usr/share/doc/$1/changelog.Debian.gz"
}

function question_mark () {
  time for i in "$@"
  do
    j="`echo "$i" | sed s/\\?.*$//`"
    echo mv "$i" "$j"
    \mv "$i" "$j"
  done
}


eval "`dircolors -b`"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# nicer
PS1='\A \u@\h:\w\$ '

# for `lynx'
export WWW_HOME='https://www.manini.cloud'

# where `del' moves files
export TRASH_DIR=$HOME/Desktop/trash

# load python defaults
export PYTHONSTARTUP="$HOME/.pythonrc.py"

# first things writen
# clear
echo -n "Today is "
date

if [[ `hostname` == asd ]]
then
    if test  $(( (`date +%s` - `< ~/.config/last_phone_backup`) )) -gt $(( 60*60*7 ))
    then
	echo "Backup of mobile phone haven't been done for (at least) a week. DO IT!"
    fi
    
    if test  $(( (`date +%s` - `< ~/.config/last_asd_backup`) )) -gt $(( 60*60*7 ))
    then
	echo "Backup of asd haven't been done for (at least) a week. DO IT!"
    fi

    # Gurobi
    
    export GUROBI_HOME="/opt/gurobi650/linux64"
    export PATH="${PATH}:${GUROBI_HOME}/bin"
    export LD_LIBRARY_PATH="${GUROBI_HOME}/lib"
fi

if hostname | grep -q sissa.it
then
    unalias diff
fi
   
if [[ $ANDROID_DATA != '' ]]
then
    sshd
fi




download_configuration () {
    config_dir_old=$(mktemp)
    mkdir $config_dir_old
    # in the future will add the --no-config option.
    if wget --quiet --quota 50m -m --no-parent -nH -l 10 --no-adjust-extension --cut-dirs=2 -R 'index*' -P $config_dir_old "$WWW_HOME/public/home_config/"
    then
	echo "Configuration files downloaded:"
	find $config_dir_old
	echo "Consider install these files by typing \`install_configuration'"
    else
	echo "Failed in retriving configuration files."
	unset $config_dir_old
	return 1
    fi

}

check_configuration () {
    for i in `find $config_dir_old/`
    do
	
	if test -f $i
	then
	    j=$HOME/`echo $i|sed  s,^$config_dir_old/,,`
	    if test -e $j
	    then
		echo diff $i 
		diff -N -d -r --color=always $i $j
		echo 
	    else
		echo "New file" $i: 
		cat $i
		echo
	    fi
	fi
    done | less -r

    unset $i
    unset $j
}	   
	


install_configuration () {
    rsync  -rlpt -v $config_dir_old/ $HOME
    date +%s > $HOME/.config/configuration_date
#    rm -fr $config_dir_old
#    unset $config_dir_old
}
	

#if test  $(( (`date +%s` - `< ~/.config/configuration_date`) )) -gt $(( 60*60*7 ))
#then
#    echo "Updating in background the configuration files."
#    download_configuration&
#fi





retrive_config_parameters () {
    if [ -f $config_dir/parameters ]
    then
	. $config_dir/parameters
    fi


    if [ "$config_repository" = "" ]
    then
	config_repository=origin
    fi
    if [ "$config_branch" = "" ]
    then
	config_branch=master
    fi

    if [ -f $config_dir/config_commit ]
    then
	config_commit=`cat $config_dir/config_commit`
    fi
}




pull_configuration () {
    retrive_config_parameters
    git --git-dir=$config_dir/.git fetch $config_repository --all
}

diff_configuration () {
    retrive_config_parameters
    git --git-dir=$config_dir/.git diff $config_commit $config_branch
}

git_install_configuration () {
    retrive_config_parameters
    $config_dir/install.sh $config_branch
}


head -n 1 ~/.bashrc


config_dir=$HOME/.home_configuration
clone_configuration () {
    git clone https://github.com/davidemanini/home_configuration $config_dir
}
