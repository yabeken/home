#!/bin/sh
CURDIR=`pwd`
ZSHENV="export ZDOTDIR=${CURDIR}/.zsh\nsource \$ZDOTDIR/.zshenv"
echo $ZSHENV > $HOME/.zshenv
