echo "Setting up yocto"

echo "List of branches: "
git ls-remote --heads --refs https://github.com/nxp-imx/imx-manifest imx-linux-*
echo "Input branch:"
read branch
mkdir tmp
git clone --depth 1 https://github.com/nxp-imx/imx-manifest -b $branch tmp/
cd tmp/
echo "Enter version (imx-<version>.xml)"
ls imx-*.xml
read version
echo "Enter desired bsp folder name:"
read name

rm -rf tmp/

cd /home/landon/work/yocto

mkdir $name
cd $name
repo init -u https://github.com/nxp-imx/imx-manifest -b $branch -m $version
repo sync -j`nproc`

echo "You may now set up a build folder. Please run the following command:"
echo "cd ~/imx-yocto-bsp; DISTRO=<distro> MACHINE=<machine name> source imx-setup-release.sh -b <build-dir>"
echo "Here is a list of DISTRO names: fsl-imx-wayland, fsl-imx-xwayland, fsl,imx-fb"
echo "For MACHINE names, please refer to the i.MX Yocto Project User's Guide for your BSP version."
