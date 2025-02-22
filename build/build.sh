#!/bin/bash -x

cd /arm-trusted-firmware
make -j$(nproc) PLAT=rk3399 "bl31"

BL31="/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf"

cd /u-boot

make rockpro64-rk3399_defconfig
make -j$(nproc) BL31="$BL31"
./tools/mkimage -n rk3399 -T rkspi -d tpl/u-boot-tpl.bin:spl/u-boot-spl.bin idbloader-spi.img

RELEASE_DIR="/src/release"
mkdir -p $RELEASE_DIR
cp u-boot.itb $RELEASE_DIR
cp idbloader-spi.img $RELEASE_DIR
