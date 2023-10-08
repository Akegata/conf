conf
====

wget https://raw.githubusercontent.com/Akegata/conf/master/install_conf.sh
bash ./install_conf.sh

Install nerd fonts:
cd ~ && mkdir Meslo && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip \
  cp Meslo/*.ttf ~/.fonts && fc-cache -fv
Choose MesloLGS Nerd Font Regular as font in the terminal.
