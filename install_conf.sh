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
}

check_repo(){
  if [ ! -d "$gitdir_conf" ]; then
    echo "The conf github repo is not cloned. Sync it with -g or -a."
    exit
  fi
}

clone_mainrepo(){
  if [ ! -d "$gitdir_conf" ]; then
    mkdir -p $gitdir_conf
    git clone https://github.com/Akegata/conf.git $gitdir_conf

  else
    echo "Repo already cloned."
  fi
}

install_tmuxconf(){
  check_repo
  eval "sudo ${package_manager} tmux xsel"

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  if [[ -L "$HOME/.tmux.conf" && "$(readlink -f $HOME/.tmux.conf)" == "$gitdir_conf/tmux/.tmux.conf" ]]; then
    echo "$HOME/.tmux.conf is already a symlink to $gitdir_conf/tmux/.tmux.conf"
  else
    if [ -f "$HOME/.tmux.conf" ]; then
      echo "$HOME/.tmux.conf moved to $HOME/.tmux.conf.bak"
      mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
    fi
    ln -s $gitdir_conf/tmux/.tmux.conf $HOME/.tmux.conf
  fi
  ~/.tmux/plugins/tpm/bin/install_plugins
  sed -i 's/  set status-right-length "100"/#  set status-right-length "100"/' ~/.tmux/plugins/tmux/catppuccin.tmux
}

install_vimconf(){
  check_repo
  eval "sudo ${package_manager} vim"

  if [ -f ~/.vim/autoload/pathogen.vim ]; then
    rm ~/.vim/autoload/pathogen.vim
  fi

  if [[ -L "$HOME/.vimrc" && "$(readlink -f $HOME/.vimrc)" == "$gitdir_conf/vim/.vimrc" ]]; then
    echo "$HOME/.vimrc is already a symlink to $gitdir_conf/vim/vimrc"
  else
    if [ -f "$HOME/.vimrc" ]; then
      echo "$HOME/.vimrc moved to $HOME/.vimrc.bak"
      mv $HOME/.vimrc $HOME/.vimrc.bak
    fi
    ln -s $gitdir_conf/vim/.vimrc $HOME/.vimrc
  fi

  vim +'PlugInstall --sync' +qa
}

install_neovimconf(){
  if [ -f /etc/debian_version ]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt install g++ -y
  fi

  eval "sudo ${package_manager} neovim gcc make"

  # Backing up conf
  mv ~/.config/nvim{,.bak}
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}

  # Install lazyvim
  git clone https://github.com/LazyVim/starter ~/.config/nvim

  # Remove lazyvims .git
  rm -rf ~/.config/nvim/.git

  # Create folder for plugins
  mkdir -p ~/.config/nvim/lua/
  ln -s $gitdir_conf/nvim/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins
}

gitdir_conf=$HOME/github/Akegata/conf
determine_package_manager

help()
{
   # Display help
   echo "Add tmux, i3 and vim config."
   echo
   echo "Syntax: install_conf [-a|g|h|i|t|v|]"
   echo "options:"
   echo "a    Install all conf (currently tmux and vim)"
   echo "g    Clone github repo"
   echo "h    Print this help."
   echo "i3   Install i3 conf."
   echo "n    Install nvim conf."
   echo "t    Install tmux conf."
   echo "v    Install vim conf."
   echo
}

while getopts "aighntv" option; do
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
    n) # Install neovim conf.
      install_neovimconf
      exit ;;
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
