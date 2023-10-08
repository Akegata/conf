#!/bin/bash

determine_package_manager(){
  declare -A osInfo;
  osInfo[/etc/debian_version]="apt-get update && sudo apt-get install -y"
  osInfo[/etc/alpine-release]="apk --update add"
  osInfo[/etc/centos-release]="yum install -y"
  osInfo[/etc/fedora-release]="dnf install -y"

  for f in ${!osInfo[@]}
  do
      if [[ -f $f ]];then
          package_manager=${osInfo[$f]}
      fi
  done

#  package="git tmux vim xsel"

#  eval "sudo ${package_manager} ${package}"
}

clone_mainrepo(){
  if [ ! -d "$HOME/github/Akegata/conf" ]; then
    mkdir -p $HOME/github/Akegata/conf
    git clone https://github.com/Akegata/conf.git $HOME/github/Akegata/conf

  else
    echo "Repo already cloned."
  fi
}

install_tmuxconf(){
  if [ ! -d "$HOME/github/Akegata/conf" ]; then
    echo "The conf github repo is not cloned. Exiting."
    exit
  fi

  eval "sudo ${package_manager} tmux"

  if [ ! -d "~/.tmux/plugins/tpm/" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [ -f "$HOME/.tmux.conf" ]; then
    echo "$HOME/.tmux.conf moved to $HOME/.tmux.conf.bak"
    mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
  fi
  ln -s $HOME/github/Akegata/conf/tmux/.tmux.conf $HOME/.tmux.conf
}

install_vimconf(){
  if [ ! -d "$HOME/github/Akegata/conf" ]; then
    echo "The conf github repo is not cloned. Exiting."
    exit
  fi

  eval "sudo ${package_manager} vim"

  mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  if [ ! -d "~/.vim/bundle/vim-sensible" ]; then
    git clone https://github.com/tpope/vim-sensible.git $HOME/.vim/bundle/vim-sensible
  fi
  if [ ! -d "~/.vim/bundle/vim-puppet" ]; then
    git clone https://github.com/rodjek/vim-puppet.git $HOME/.vim/bundle/vim-puppet
  fi

  if [ -f "$HOME/.vimrc" ]; then
    echo "$HOME/.vimrc moved to $HOME/.vimrc.bak"
    mv $HOME/.vimrc $HOME/.vimrc.bak
  fi
  ln -s $HOME/github/Akegata/conf/vim/.vimrc $HOME/.vimrc
}

determine_package_manager

help()
{
   # Display help
   echo "Add tmux, i3 and vim config."
   echo
   echo "Syntax: install_conf [-a|g|h|i|t|v|]"
   echo "options:"
   echo "a   Install all conf (currently tmux and vim)"
   echo "g   Clone github repo"
   echo "h   Print this help."
   echo "i3  Install i3 conf."
   echo "t   Install tmux conf."
   echo "v   Install vim conf."
   echo
}

while getopts "aightv" option; do
  case $option in
    a) # Install all conf.
      clone_mainrepo
      install_tmuxconf
      install_vimconf
      exit ;;
    i) # Install i3 conf.
      echo "Install i3"
      exit ;;
    g) # Clone github repo.
      clone_mainrepo
      exit;;
    h) # display Help
      help
      exit;;
    t) # Install tmux conf.
      #echo package_manager = ${package_manager} 
      install_tmuxconf
      exit;;
    v) # Install vim conf.
      install_vimconf
      exit;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit;;
  esac
done

help
