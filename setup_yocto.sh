#!/bin/bash

FILE=/home/$USER/bin/repo

echo "Installing dependent packages."

sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential \
chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
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

echo "Setting up yocto"

cd /home/$USER

mkdir imx-yocto-bsp
cd imx-yocto-bsp
/home/$USER/bin/repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-mickledore -m imx-6.1.36-2.1.0.xml
/home/$USER/bin/repo sync

echo "You may now set up a build folder. Please run the following command:"
echo "DISTRO=<distro name> MACHINE=<machine name> source imx-setup-release.sh -b <build-dir>"
echo "Here is a list of DISTRO names: fsl-imx-wayland, fsl-imx-xwayland, fsl,imx-fb"
echo "For MACHINE names, see the following link: "
