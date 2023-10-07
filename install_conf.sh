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

install_packages
mkdir $HOME/github/Akegata
git clone https://github.com/Akegata/conf.git $HOME/github/Akegata
