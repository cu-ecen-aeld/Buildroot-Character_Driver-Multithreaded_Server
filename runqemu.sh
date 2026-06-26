#!/bin/bash

# ------------------------------------------------------------------------------
# File        : runqemu.sh
#
# Description : Launch script for running the Buildroot-generated ARM64 Linux
#               image inside QEMU (qemu-system-aarch64).
#
# Purpose     : Boots the generated kernel and root filesystem in a virtual
#               ARM64 environment with networking and port forwarding enabled.
#
# Host Port Forwarding:
#   10022 -> Guest SSH (22)
#   9000  -> Guest application/server port
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Launch QEMU ARM64 virtual machine
#
# Machine      : ARM "virt" platform
# CPU          : Cortex-A53, single core
# Console      : Serial console (ttyAMA0), headless mode
# Kernel       : Buildroot-generated Linux kernel image
# Root Filesystem : Buildroot-generated ext4 root filesystem
# Networking   : User-mode networking with port forwarding
# Port Forward : Host 10022 -> Guest SSH (22)
#                Host 9000  -> Guest application (9000)

qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a53 \
    -nographic \
    -smp 1 \
    -kernel buildroot/output/images/Image \
    -append "rootwait root=/dev/vda console=ttyAMA0" \
    -netdev user,id=eth0,hostfwd=tcp::10022-:22,hostfwd=tcp::9000-:9000 \
    -device virtio-net-device,netdev=eth0 \
    -drive file=buildroot/output/images/rootfs.ext4,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -device virtio-rng-pci