#!/bin/bash

dir=~/dotfiles/vagrant
olddir=~/dotfiles_old
files="bash_aliases gitconfig tmux.conf tmux-panes.conf"

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
  mv ~/.$file ~/dotfiles_old/
  ln -s $dir/$file ~/.$file
  echo "mapped ~/.$file => $dir/$file"
done

dir=~/dotfiles
files="bundle"

echo "Changing to the $dir directory"
cd $dir

for file in $files; do
  mv ~/.$file ~/dotfiles_old/
  ln -s $dir/$file ~/.$file
  echo "mapped ~/.$file => $dir/$file"
done
