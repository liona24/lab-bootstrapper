#!/bin/bash

sudo apt update --fix-missing
sudo apt upgrade -y

# Setup VirtualBox Guest Additions

sudo apt install build-essential module-assistant
read -p "Path to VirtualBox Guest Additions: " VBOX_GUEST_PATH
sudo bash $VBOX_GUEST_PATH/VBoxLinuxAdditions.run

# Install tools

sudo apt remove -y vim
sudo apt install -y \
    python3-neovim \
    curl \
    wget \
    unzip \
    ca-certificates \
    git \
    python3-pip \
    cmake \
    xclip \
    tmux \
    ripgrep \
    ltrace \
    strace \
    gdb \
    libssl-dev \
    libffi-dev \
    python3-dev \
    ruby \
    gdbserver \
    netcat


# Some common python tools for CTF stuff
pip3 install --upgrade pip
pip3 install virtualenv httpx angr cryptography unicorn ropper capstone mitmproxy ipython
python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
sudo gem install one_gadget

# Custom utility 
(mkdir $HOME/.local || : ) 2> /dev/null
git clone https://github.com/liona24/utility-scripts.git $HOME/.local/utility-scripts

# configure VIM
curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

(mkdir -p $HOME/.config/nvim || : ) 2> /dev/null
cp ./vimrc $HOME/.config/nvim/init.vim
vim --headless +PlugInstall +qall > /dev/null

# configure TMUX

cp ./tmux.conf $HOME/.tmux.conf

# overclocked bash history

echo "TODO: Add bash_history"

# Make sure environment variables are setup

echo "export PATH=\"\$PATH:\$HOME/.local/utility-scripts\"" >> $HOME/.bashrc
echo "export LC_CTYPE=C.UTF-8" >> $HOME/.bashrc


