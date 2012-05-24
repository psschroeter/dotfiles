#!/bin/bash
dotdir="$(dirname "$0")"
thisdate=$(date +%Y%m%d%M%S)
cd $dotdir
dotdir=$(pwd -P)

function doIt() {
#  mkdir -p ._backup/$thisdate
  for f in $(ls -a .); do 
    [ "$f" = "." ] && continue
    [ "$f" = ".." ] && continue
    [ "$f" = ".osx" ] && continue
    [ "$f" = ".brew" ] && continue
    [ "$f" = ".git" ] && continue
    [ "$f" = "._backup" ] && continue
    [ "$f" = ".vim" ] && continue
    [[ ! "$f" =~ ^\. ]] && continue
#    mv $HOME/$f $dotdir/._backup/$thisdate
#    ln -s $dotdir/$f $HOME/$f
    echo "ln -s $dotdir/$f $HOME/$f"
  done
#  mv $HOME/.vim $dotdir/._backup/$thisdate
#  mkdir -p $HOME/.vim/backups
#  mkdir -p $HOME/.vim/undo
#  mkdir -p $HOME/.vim/swaps
  for f in $(ls .vim); do 
    [ "$f" = "backups" ] && continue
    [ "$f" = "undo" ] && continue
    [ "$f" = "swaps" ] && continue
#    ln -s $dotdir/.vim/$f $HOME/.vim/$f
    echo "ln -s $dotdir/.vim/$f $HOME/.vim/$f"
  done
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
source ~/.bash_profile