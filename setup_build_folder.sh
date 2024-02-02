echo "Setting up yocto"

echo "Please go to github.com/nxp-imx/imx-manifest and choose the following:"
echo "Enter branch:"
read branch
echo "Enter version (imx-<version>.xml)"
read version

cd /home/$USER

mkdir imx-yocto-bsp
cd imx-yocto-bsp
/home/$USER/bin/repo init -u https://github.com/nxp-imx/imx-manifest -b $branch -m $version
/home/$USER/bin/repo sync

echo "You may now set up a build folder. Please run the following command:"
echo "cd ~/imx-yocto-bsp; DISTRO=<distro name> MACHINE=<machine name> source imx-setup-release.sh -b <build-dir>"
echo "Here is a list of DISTRO names: fsl-imx-wayland, fsl-imx-xwayland, fsl,imx-fb"
echo "For MACHINE names, please refer to the i.MX Yocto Project User's Guide for your BSP version."

