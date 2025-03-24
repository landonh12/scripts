#!/bin/bash

FILE=/home/$USER/bin/repo

echo "Installing dependent packages."

sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential \
chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
iputils-ping python3-git python3-jinja2 libsdl1.2-dev \
python3-subunit mesa-common-dev zstd liblz4-tool file python-is-python3 locales -y

sudo locale-gen en_US.UTF-8

echo "Checking to see if repo is installed."

if [ -f "$FILE" ] 
then
	echo "Repo already installed."
else
	echo "Installing repo..."
	cd ~
	mkdir ~/bin
	curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	export PATH=~/bin:$PATH
	echo "export PATH=~/bin:$PATH" >> ~/.bashrc
fi

echo "Setting up git..."

read -p 'Email: ' emailvar
read -p 'First and Last Name: ' namevar

git config --global user.name $namevar
git config --global user.email $emailvar

echo DONE!
