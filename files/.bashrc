#--- ble.sh Line Editor - First Step of Activation

# Werkstatt - line below must the first line of code.
 [[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#--- General Configuration

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

#--- Terminal Window

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#--- Globbing

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#--- History

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

#--- Configuratons of Utility Programmes

##------ chroot

# Set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

##------ gcc

# Colored GCC warnings and errors.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

##------ less

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

##------ ls

# Enable color support of ls, dir, grep and variants.
if [ -x /usr/bin/dircolors ]; then
    # dircolors sets the LS_COLORS environment variable then exports it.
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

#--- Alias definitions

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#--- Completions

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#--- Import user configuration

# Write bash customizations in the file below.
if [[ -f ~/.bash_myconf]]; then
    . ~/.bash_myconf
fi

#--- Activate Starship Prompt

eval "$(starship init bash)"

#--- ble.sh Line Editor - Second Step of Activation

[[ ${BLE_VERSION-} ]] && ble-attach
# Werkstatt - above line must be the last line of code.
