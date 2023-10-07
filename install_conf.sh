#!/bin/bash

install_packages(){
  declare -A osInfo;
  osInfo[/etc/debian_version]="apt-get install -y"
  osInfo[/etc/alpine-release]="apk --update add"
  osInfo[/etc/centos-release]="yum install -y"
  osInfo[/etc/fedora-release]="dnf install -y"

  for f in ${!osInfo[@]}
  do
      if [[ -f $f ]];then
          package_manager=${osInfo[$f]}
      fi
  done

  package="git tmux vim"

  ${package_manager} ${package}
}

gitclone(){
  mkdir $HOME/github/Akegata/conf
  git clone https://github.com/Akegata/conf.git $HOME/github/Akegata/conf
}

create_symlinks(){
  ln -s $HOME/github/Akegata/conf/tmux/.tmux.conf $HOME/.tmux.conf
}

install_packages
gitclone
create_symlinks
