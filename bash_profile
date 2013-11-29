#!/bin/bash

# Boxen
if [ -f /opt/boxen/env.sh ]
then
  source /opt/boxen/env.sh
fi

# custom sources
source ~/dotfiles/scripts/git-completion
source ~/dotfiles/scripts/exports
source ~/dotfiles/scripts/aliases

if [ -f ~/.env ]
then
  source ~/.env
fi
