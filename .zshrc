# -----------------
# General Settings
# -----------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export PATH=~/.home/bin/:/usr/local/bin/:/usr/local/sbin/:/bin/:/sbin/:$PATH
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man

# homebrew
export PATH=/usr/local/share/python/:~/bin/:$PATH

# alias
alias gip='wget -q -O - ipcheck.ieserver.net'
alias cdw='cd /home/yabe/Documents/workspace'

# project
export PROJECT_DIR=/home/yabe/Documents/workspace/

# django
alias runserver='python manage.py runserver 0.0.0.0:8000'
alias shell='python manage.py shell'
alias syncdb='python manage.py syncdb'

# color
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"

# prompt
autoload colors && colors
setopt prompt_subst
PROMPT="
 [%n]%{${fg[yellow]}%}%~%{${reset_color}%} 
$ "
PROMPT2="%_%% "
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt share_history
setopt hist_ignore_space
setopt interactive_comments

# history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end 

# cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^\^' cdup
function chpwd() {
#   ls -v -F --color=auto
  ls
}

# コマンドの修正
#setopt correct

# ls
setopt list_packed

# completion
autoload -U compinit && compinit
autoload predict-on && predict-on
setopt auto_list
setopt auto_menu
setopt auto_param_slash
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=1
typeset -A myabbrev
myabbrev=(
    "L"    "| less"
    "G"    "| grep"
    "tx"    "tar zxf"
    "tc"    "tar zcf"
    "rs"    "python manage.py runserver"
)
my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev

# emacs key binding
bindkey -e

# os
case "${OSTYPE}" in
freebsd*|darwin*)
alias ls="ls -G -w"
;;
linux*)
alias ls="ls --color"
;;
esac
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"

######################
# show current branch
#
# @see
# http://stackoverflow.com/questions/1128496/to-get-a-prompt-which-indicates-git-branch-in-zsh

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

