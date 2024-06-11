echo "Setting up yocto"

echo "Please go to github.com/nxp-imx/imx-manifest and choose the following:"
echo "Enter branch:"
echo "List of branches: "
echo "1. imx-linux-nanbield LF6.6"
echo "2. imx-linux-mickledore LF6.1.55/22"
echo "3. imx-linux-langdale LF6.1.1"
echo "4. imx-linux-kirkstone LF5.15.71/52/32"
echo "5. imx-linux-honister LF5.15.5"
echo "6. imx-linux-hardknott LF5.10.72/52/35"
read branch
echo "Enter version (imx-<version>.xml)"
echo "1. imx-6.6.3-1.0.0.xml"
echo "2. imx-6.1.55-2.2.0.xml, imx-6.1.36-2.1.0.xml, imx-6.1.22-1.0.0.xml"
echo "3. imx-6.1.1-1.0.0.xml"
echo "4. imx-5.15.71-2.2.2.xml, imx-5.15.52-2.1.0.xml, imx-5.15.32-2.0.0.xml"
echo "5. imx-5.15.5-1.0.0.xml"
echo "6. imx-5.10.72-2.2.3.xml, imx-5.10.52-2.2.0.xml, imx-5.10.35-2.0.0.xml"
read version
echo "Enter desired bsp folder name:"
read name

cd /home/$USER/work/yocto

mkdir $name
cd $name
repo init -u https://github.com/nxp-imx/imx-manifest -b $branch -m $version
repo sync -j`nproc`

echo "You may now set up a build folder. Please run the following command:"
echo "cd ~/imx-yocto-bsp; DISTRO=<distro name> MACHINE=<machine name> source imx-setup-release.sh -b <build-dir>"
echo "Here is a list of DISTRO names: fsl-imx-wayland, fsl-imx-xwayland, fsl,imx-fb"
echo "For MACHINE names, please refer to the i.MX Yocto Project User's Guide for your BSP version."
