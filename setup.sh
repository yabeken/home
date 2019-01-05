#!/bin/sh

# zsh
CURDIR=`pwd`
ZSHENV="export ZDOTDIR=${CURDIR}/.zsh\nsource \$ZDOTDIR/.zshenv"
echo $ZSHENV > $HOME/.zshenv

export ZPLUG_HOME=$HOME/.zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME

