#!/bin/bash

determine_package_manager(){
  declare -A osInfo;
  osInfo[/etc/debian_version]="apt-get update && sudo apt-get install -y"
  osInfo[/etc/alpine-release]="apk --update add"
  osInfo[/etc/centos-release]="yum install -y"
  osInfo[/etc/fedora-release]="dnf install -y"
  osInfo[/etc/almalinux-release]="dnf install -y"

  for f in ${!osInfo[@]}
  do
      if [[ -f $f ]];then
          package_manager=${osInfo[$f]}
      fi
  done
}

install_default_packages(){
  if [ -f /etc/centos-release ]; then
    rhel_version=$(cat /etc/redhat-release | grep -oE '[0-9]+' | head -1)
    if [ ! -f ~/.local/bin/nvim ]; then
      eval "sudo ${package_manager} epel-release"
    fi
  fi

  eval "sudo ${package_manager} git curl"
}

check_repo(){
  if [ ! -d "$gitdir_conf" ]; then
    echo "The conf github repo is not cloned. Sync it with -g or -a."
    exit
  fi
   33   │ fi
    1   }
    2
    3   clone_mainrepo(){
    4   │ if [ ! -d "$gitdir_conf" ]; then
    5   │ │ mkdir -p $gitdir_conf
    6   │ │ git clone https://github.com/Akegata/conf.git $gitdir_conf
    7   │
    8   │ else
    9   │ │ echo "Syncing repo."
   10   │ │ cd $gitdir_conf && git pull
   11   │ fi
   12   }
}

clone_mainrepo(){
  if [ ! -d "$gitdir_conf" ]; then
    mkdir -p $gitdir_conf
    git clone https://github.com/Akegata/conf.git $gitdir_conf

  else
    echo "Syncing repo."
    cd $gitdir_conf && git pull
  fi
}

install_bat(){
  check_repo
  if [ -f /etc/debian_version ]; then
    eval "sudo ${package_manager} bat"
  elif [[ -f /etc/centos-release  ]]; then
    curl -o bat.zip -L https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-i686-unknown-linux-musl.tar.gz
    tar -zxf bat.zip
    sudo mv bat-v0.24.0-i686-unknown-linux-musl/bat /usr/local/bin/batcat
  fi
  if [ ! -f ~/.config/bat/config ]; then
    mkdir -p ~/.config/bat/themes
    ln -s $gitdir_conf/bat/.config/bat/config $HOME/.config/bat/config 
    ln -s $gitdir_conf/bat/.config/bat/themes/Catppuccin-mocha.tmTheme $HOME/.config/bat/themes/
    batcat cache --build
  fi
}

install_tmuxconf(){
  check_repo
  if [ $rhel_version == 8 ]; then
    sudo dnf install http://galaxy4.net/repo/galaxy4-release-$rhel_version-current.noarch.rpm -y
  fi

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
  check_repo
  if [ -f /etc/debian_version ]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    eval "sudo ${package_manager} neovim gcc make g++"
  fi

  if [ -f /etc/centos-release ]; then
    if [ ! -f ~/.local/bin/nvim ]; then
      eval "sudo ${package_manager} compat-lua-libs libtermkey libtree-sitter libvterm luajit luajit2.1-luv msgpack unibilium xsel make gcc gcc-c++"

      wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
      tar xvzf nvim-linux64.tar.gz
      mv nvim-linux64 ~/.local/share/

      mkdir -p ~/.local/bin
      ln -sf ~/.local/share/nvim-linux64/bin/nvim ~/.local/bin/nvim
    else 
      echo "Nvim already installed"
    fi
  fi


  if [ ! -f ~/.config/nvim/lua/config/lazy.lua ]; then
    # Backing up conf
    mv ~/.config/nvim{,.bak}
    mv ~/.local/share/nvim{,.bak}
    mv ~/.local/state/nvim{,.bak}
    mv ~/.cache/nvim{,.bak}

    # Install lazyvim
    git clone https://github.com/LazyVim/starter ~/.config/nvim

    # Remove lazyvims .git
    rm -rf ~/.config/nvim/.git
  fi

  # Create folder for plugins
  if [ ! -d ~/.config/nvim/lua/plugins ]; then
    mkdir -p ~/.config/nvim/lua/plugins
  fi

  plugins_gitdir="$gitdir_conf/nvim/.config/nvim/lua/plugins"
  plugins_target_dir="$HOME/.config/nvim/lua/plugins"
  keymaps_file=".config/nvim/lua/config/keymaps.lua"
  options_file=".config/nvim/lua/config/options.lua"

  # Make symlinks for all the plugins.
  for source_file in "$plugins_gitdir"/*; do
    file_name=$(basename "$source_file")
    target_file="$plugins_target_dir/$file_name"
 
    if [ -e "$target_file" ]; then
      if [ -L "$target_file" ]; then
        # If it exists and is a symlink, remove the existing symlink
        rm "$target_file"
        echo "Removed existing symlink $target_file"
      else
        # If it exists and is not a symlink, rename the existing file to .bak
        mv "$target_file" "$target_file.bak"
        echo "Renamed $target_file to $target_file.bak"
      fi
    fi
  
    # Create a symbolic link from source to target directory
    ln -s "$source_file" "$target_file"
    echo "Created symlink from $source_file to $target_file"
  done

  if [[ -L "$HOME/$keymaps_file" && "$(readlink -f $HOME/$keymaps_file)" == "$gitdir_conf/nvim/$keymaps_file" ]]; then
    echo "$HOME/$keymaps_file is already a symlink to $gitdir_conf/nvim/$keymaps_file"
  else
    if [ -f "$HOME/$keymaps_file" ]; then
      echo "$HOME/$keymaps_file moved to $HOME/$keymaps_file.bak"
      mv $HOME/$keymaps_file $HOME/$keymaps_file.bak
    fi
    ln -s $gitdir_conf/nvim/$keymaps_file $HOME/$keymaps_file
  fi

  if [[ -L "$HOME/$options_file" && "$(readlink -f $HOME/$options_file)" == "$gitdir_conf/nvim/$options_file" ]]; then
    echo "$HOME/$options_file is already a symlink to $gitdir_conf/nvim/$options_file"
  else
    if [ -f "$HOME/$options_file" ]; then
      echo "$HOME/$options_file moved to $HOME/$options_file.bak"
      mv $HOME/$options_file $HOME/$keymaps_file.bak
    fi
    ln -s $gitdir_conf/nvim/$options_file $HOME/$options_file
  fi
}

install_ohmybash(){
  check_repo
  if [ ! -d ~/.oh-my-bash ]; then
    eval "sudo ${package_manager} mercurial"
  	git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash

  	if [ -f ~/.bashrc ]; then
  		mv ~/.bashrc ~/.bashrc.orig
  	fi
#  	cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
#  	# Set the Oh My Bash theme in .bashrc
#  	sed -i '/^OSH_THEME/s/.*/OSH_THEME="agnoster"/' ~/.bashrc

    ln -s $gitdir_conf/ohmybash/.bashrc $HOME/.bashrc

    ln -s $gitdir_conf/ohmybash/.oh-my-bash/custom/themes/* $HOME/.oh-my-bash/custom/themes/

  	# Source .bashrc to apply changes in the current session
  	source ~/.bashrc

  else
      echo "Oh my bash already installed."
  fi

  source ~/.bashrc
  clear
}

gitdir_conf=$HOME/github/Akegata/conf
determine_package_manager
install_default_packages

help()
{
   # Display help
   echo "Add ohmybash, nvim, tmux and vim config."
   echo
   echo "Syntax: install_conf [-a|b|g|h|i|n|o|t|v|]"
   echo "options:"
   echo "a    Install all conf (currently tmux and vim)"
   echo "b    Install bat"
   echo "g    Clone github repo"
   echo "h    Print this help."
   echo "i3   Install i3 conf."
   echo "o    Install oh my bash."
   echo "n    Install nvim conf."
   echo "t    Install tmux conf."
   echo "v    Install vim conf."
   echo
}

while getopts "abighnotv" option; do
  case $option in
    a) # Install all conf.
      clone_mainrepo
      install_bat
      install_tmuxconf
      install_vimconf
      install_neovimconf
      install_ohmybash
      exit ;;
    b) # Install bat
      install_bat
      exit;;
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
    o) # Install ohmybash conf.
      install_ohmybash
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
