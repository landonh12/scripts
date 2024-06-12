#!/bin/sh -eu
# shellcheck shell=ash

# This script mounts the rootfs partition of a wic.xz image and copy the rootfs
# to a directory. The roofs partition is at partition 3.

if ! command -v losetup > /dev/null ; then
    echo "ERROR: losetup is missing" >&2
    exit 1
fi

if ! args=$(getopt -o '' --long 'help,image-file:,output-directory:' -n "$(basename "$0")" -- "$@") ; then
    exit 1
fi

usage() {
    echo "Usage: $(basename "$0") [OPTION]"
    echo "Copy the rootfs from a wic.xz image to a directory"
    echo ""
    echo "Mandatory options:"
    echo "    --image-file <the image wic.xz filename>"
    echo "    --output-directory <the directory to copy the rootfs>"
    echo "Optional options:"
    echo "    --help"
    echo ""
    echo "Example:"
    echo "$0 \\"
    echo "    --image-file yocto-image.rootfs.wic.xz \\"
    echo "    --output-directory /srv/nfs/rootfs"
}

IMAGE_FILE=
OUTPUT_DIRECTORY=
ROOTFS_PARTITION_NUMBER="p3"

eval set -- "${args}"
unset args
while true ; do
    case "$1" in
    --help)
        usage
        exit 0
        ;;
    --image-file)
        IMAGE_FILE="$2"
        shift 2
        ;;
    --output-directory)
        OUTPUT_DIRECTORY="$2"
        shift 2
        ;;
    --) shift; break;;
    *) echo "Internal error" >&1 ; exit 3;;
    esac
done

if [ -z "${IMAGE_FILE}" ] || [ -z "${OUTPUT_DIRECTORY}" ] ; then
    usage 1>&2
    exit 1
fi

# Check if image file exists.
if [ ! -f "${IMAGE_FILE}" ] ; then
    echo "ERROR: Image file ${IMAGE_FILE} does not exist." >&2
    exit 1
fi
XZ_IMAGE_FILENAME=$(basename "${IMAGE_FILE}")

# Check if directory exists
if [ ! -d "${OUTPUT_DIRECTORY}" ] ; then
    echo "Directory ${OUTPUT_DIRECTORY} does not exist. Creating..." >&1
    mkdir -p "${OUTPUT_DIRECTORY}"
fi

TMP_DIRECTORY="$(mktemp --tmpdir --directory "$(basename "$0").XXXXX")"
cleanup_tmp_dir () {
    rm -fr "${TMP_DIRECTORY}"
}

WIC_IMAGE_FILENAME="${XZ_IMAGE_FILENAME%.xz}"
TMP_WIC_IMAGE_FILE="${TMP_DIRECTORY}/${WIC_IMAGE_FILENAME}"

# Decompress wic.xz file
xz --decompress --keep --stdout "${IMAGE_FILE}" > "${TMP_WIC_IMAGE_FILE}"
if [ ! -f "${TMP_WIC_IMAGE_FILE}" ] ; then
    echo "ERROR: Temporary .wic image file ${TMP_WIC_IMAGE_FILE} does not exist."
    cleanup_tmp_dir
    exit 1
fi

# Find the first unused loop device.
GET_LOOP_DEVICE=$(losetup -f)
cleanup_loop_device () {
    sudo losetup -d "${GET_LOOP_DEVICE}"
}

ROOTFS_IMAGE_PARTITION="${GET_LOOP_DEVICE}${ROOTFS_PARTITION_NUMBER}"

sudo losetup -P "${GET_LOOP_DEVICE}" "${TMP_WIC_IMAGE_FILE}"
# The partition 3 has the rootfs, check if exists
if [ ! -b "${ROOTFS_IMAGE_PARTITION}" ] ; then
    echo "ERROR: No partition ${ROOTFS_IMAGE_PARTITION} available..."
    cleanup_loop_device
    cleanup_tmp_dir
    exit 1
fi

TMP_ROOTFS_DIRECTORY="${TMP_DIRECTORY}/rootfs"
cleanup_umount_dir () {
    sudo umount "${TMP_ROOTFS_DIRECTORY}"
}
mkdir -p "${TMP_ROOTFS_DIRECTORY}"

sudo mount "${ROOTFS_IMAGE_PARTITION}" "${TMP_ROOTFS_DIRECTORY}"
sudo cp -ra "${TMP_ROOTFS_DIRECTORY}/"* "${OUTPUT_DIRECTORY}"

cleanup_umount_dir
cleanup_loop_device
cleanup_tmp_dir
