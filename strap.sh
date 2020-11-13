#!/bin/bash

OLD_PWD=$(pwd)

sudo apt update --fix-missing
sudo apt upgrade -y

# Setup VirtualBox Guest Additions

sudo apt install -y build-essential module-assistant
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
    python3-venv \
    cmake \
    xclip \
    tmux \
    ripgrep \
    binutils \
    ltrace \
    strace \
    gdb \
    gdbserver \
    gdb-multiarch \
    libssl-dev \
    libffi-dev \
    python3-dev \
    ruby \
    netcat \
    gnupg-agent \
    ghex \
    openjdk-11-jdk \
    zsh \
    httpie

# Docker for easier backwards compatiblity and stuff
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# Setup new shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)
zsh

shell_config=$HOME/.zshrc

git clone https://github.com/zdharma/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  ${ZSH_CUSTOM:$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed 's/^plugins=\(.*\)/plugins=(git fast-syntax-highlighting zsh-autosuggestions)/' $shell_config > "$shell_config.tmp"
mv "$shell_config.tmp" $shell_config

# Some common python tools for CTF stuff
python3 -m pip install --upgrade pip

python3 -m pip install --user pipx
echo "export PATH=\"\$PATH:\$HOME/.local/bin\"" >> $shell_config
source $shell_config

python3 -m pipx install mitmproxy
python3 -m pipx install ropper

python3 -m pip install --upgrade virtualenv httpx ipython
mkdir $HOME/venvs
cd $HOME/venvs

for package in "angr" "pwntools" "cryptography" "pycryptodomex"
do
    virtualenv $package || continue
    source $package/bin/activate || continue
    python3 -m pip install $package
    deactivate
done

cd $OLD_PWD

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

# Custom utility 
git clone https://github.com/liona24/utility-scripts.git $HOME/.local/utility-scripts

# configure VIM
curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

(mkdir -p $HOME/.config/nvim || : ) 2> /dev/null
cp ./vimrc $HOME/.config/nvim/init.vim
vim --headless +PlugInstall +qall > /dev/null

# configure TMUX

cp ./tmux.conf $HOME/.tmux.conf

# Make sure environment variables are setup

echo "export PATH=\"\$PATH:\$HOME/.local/utility-scripts\"" >> $shell_config
echo "export LC_CTYPE=C.UTF-8" >> $shell_config

