# Default shell configuration

# Login umask
umask 0022

# Default command behavior
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias less='less -cQR'
alias ls='ls --color=auto'

# Command variants
alias dtar='tar --no-same-owner --numeric-owner --owner=0 --group=0 --preserve'
alias l='ls -1A'
alias la='ls -al'
alias ll='ls -Al'

# Set a default editor.
EDITOR=emacs ; export EDITOR
VISUAL=$EDITOR ; export VISUAL

# Configure shell history to keep only useful records.
HISTCONTROL=ignoreboth ; export HISTCONTROL
HISTSIZE=1000 ; export HISTSIZE

# Select the default language/encoding.
test "${TERM%-color}" = mach-gnu && LANG=C || LANG=en_US.UTF-8 ; export LANG
LANGUAGE=$LANG ; export LANGUAGE
LC_ALL=$LANG ; export LC_ALL

# Choose a MOTD based on encoding.
MOTD=/etc/motd ; test "${LANG##*.}" = UTF-8 && MOTD=$MOTD.UTF8 ; export MOTD

# Configure a default system path.
PATH="$HOME/.local/bin:/usr/bin:/usr/sbin:/bin:/sbin" ; export PATH

# Provide useful information in the shell prompt.
PS1='[$?:\u@\h \W]\$ ' ; export PS1

# Color file listings.
eval $(dircolors --sh)

# Include individual package settings.
for conf in /etc/profile.d/*.sh ; do . "$conf" ; done
