#!/bin/bash
dotdir="$(dirname "$0")"
thisdate=$(date +%Y%m%d%M%S)
cd $dotdir
dotdir=$(pwd -P)

function doIt() {
  for f in $(ls -a .); do 
    case $f in
      .|..|.osx|.brew|.git|.githooks|.vim|._backup)
        ;;
      .*)
        echo "ln -f $dotdir/$f $HOME/$f"
        ln -f $dotdir/$f $HOME/$f
        ;;
    esac
  done
  mkdir -p $HOME/.vim/backups
  mkdir -p $HOME/.vim/undo
  mkdir -p $HOME/.vim/swaps
  for f in $(ls .vim); do 
    case $f in
      backups|undo|swaps)
        ;;
      *)
        ln -s $dotdir/.vim/$f $HOME/.vim/$f
        echo "ln -s $dotdir/.vim/$f $HOME/.vim/$f"
        ;;
    esac
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
