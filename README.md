conf
====
## Install configuration files:
```
wget https://raw.githubusercontent.com/Akegata/conf/master/install_conf.sh
bash ./install_conf.sh -a
```

## Install nerd fonts:
```
cd ~ && mkdir Meslo && cd Meslo && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip unzip Meslo.zip && cp *.ttf ~/.fonts && fc-cache -fv
```
Choose MesloLGS Nerd Font Regular as font in the terminal.

## Custom keymaps:
```
tmux:
Ctrl+f = command
Ctrl+! = split window vertically
Ctrl+" = split window horizontally
Ctrl+y = toggle pane synchronization
Shift+arrow = select pane

vim:
Ctrl+o = Toggle NERDtree
Ctrl+l = NERDtree focus
Ctrl+p = NERDtreeFind

neovim:
Ctrl+o = Toggle Neo-tree
Ctrl+l = Neo-tree focus
```
## Info

Installation tested on CentOS Stream 8, 9 and Ubuntu 22.04.

## Todo

Add batcat configuration.
Add i3 configuration.
