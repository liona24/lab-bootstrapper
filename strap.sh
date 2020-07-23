#!/bin/bash

OLD_PWD=$(pwd)

sudo apt update --fix-missing
sudo apt upgrade -y

# Setup VirtualBox Guest Additions

sudo apt install build-essential module-assistant
read -p "Path to VirtualBox Guest Additions: " VBOX_GUEST_PATH
if [ ! -z "$VBOX_GUEST_PATH" ]; then 
    sudo bash $VBOX_GUEST_PATH/VBoxLinuxAdditions.run
else
    echo "Skipping VirtualBox Guest Additions."
fi


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
    netcat \
    gnupg-agent

# Docker for backwards easier backwards compatiblity and stuff
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce


# Some common python tools for CTF stuff
pip3 install --upgrade pip
pip3 install virtualenv httpx angr cryptography unicorn ropper capstone mitmproxy ipython
python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# install keystone. uff
cd /tmp
git clone https://github.com/keystone-engine/keystone.git 
cd keystone 
mkdir build && cd build 
../make-share.sh
sudo make install 
sudo ldconfig 
cd ../bindings/python 
sudo python3 setup.py install
cd $OLD_PWD

sudo gem install one_gadget

(mkdir $HOME/.local || : ) 2> /dev/null

# qira
git clone https://github.com/geohot/qira.git $HOME/qira
cd $Home/qira
sudo docker build -t qira -f docker/Dockerfile .
cd $OLD_PWD

# Custom utility 
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


