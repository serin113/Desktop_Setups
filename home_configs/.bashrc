#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias home='cd /home/serin/'
alias conky-restart='killall conky; conky; conky -c ~/.conkystatrc'
alias conky-edit='leafpad ~/.conkyrc &'
alias conky-stat-edit='leafpad ~/.conkystatrc &'
alias removeorphan='~/scripts/removeorphan'
alias reflector='~/scripts/reflector'
alias xyzzy='echo "Nothing happens."'
alias notes='leafpad ~/notes &'
alias fontrefresh='fc-cache && mkfontscale && mkfontdir'

#archey
#screenfetch
#alsi

source /usr/share/doc/pkgfile/command-not-found.bash
